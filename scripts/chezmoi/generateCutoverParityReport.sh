#!/bin/bash

set -euo pipefail

if [ "$#" -ne 6 ]; then
  printf 'usage: %s <repo_root> <baseline_file> <state_dir> <import_targets_file> <denylist_file> <exception_file>\n' "$0" >&2
  exit 64
fi

REPO_ROOT="$1"
BASELINE_FILE="$2"
STATE_DIR="$3"
IMPORT_TARGETS_FILE="$4"
DENYLIST_FILE="$5"
EXCEPTION_FILE="$6"
MANAGED_FILE="$STATE_DIR/chezmoi-managed-files.json"
REPORT_FILE="$STATE_DIR/chezmoi-post-apply-report.md"
JSON_FILE="$STATE_DIR/chezmoi-post-apply-report.json"

resolve_path() {
  case "$1" in
    /*) printf '%s\n' "$1" ;;
    *) printf '%s/%s\n' "$REPO_ROOT" "$1" ;;
  esac
}

BASELINE_FILE="$(resolve_path "$BASELINE_FILE")"
IMPORT_TARGETS_FILE="$(resolve_path "$IMPORT_TARGETS_FILE")"
DENYLIST_FILE="$(resolve_path "$DENYLIST_FILE")"
EXCEPTION_FILE="$(resolve_path "$EXCEPTION_FILE")"

mkdir -p "$STATE_DIR"

MANAGED_TMP="$(mktemp)"
trap 'rm -f "$MANAGED_TMP"' EXIT

chezmoi -S "$REPO_ROOT" managed --include=files,symlinks --format json --path-style absolute > "$MANAGED_TMP"

if jq -e . >/dev/null 2>&1 < "$MANAGED_TMP"; then
  cp "$MANAGED_TMP" "$MANAGED_FILE"
else
  python3 - "$MANAGED_TMP" "$MANAGED_FILE" <<'PY'
import json
import sys
from pathlib import Path

source = Path(sys.argv[1])
destination = Path(sys.argv[2])
lines = [line.strip() for line in source.read_text().splitlines() if line.strip()]
destination.write_text(json.dumps(lines, indent=2) + "\n")
PY
fi

python3 - "$REPO_ROOT" "$BASELINE_FILE" "$IMPORT_TARGETS_FILE" "$DENYLIST_FILE" "$EXCEPTION_FILE" "$MANAGED_FILE" "$REPORT_FILE" "$JSON_FILE" <<'PY'
import json
import sys
from pathlib import Path


repo_root = Path(sys.argv[1]).resolve()
baseline_file = Path(sys.argv[2])
import_targets_file = Path(sys.argv[3])
denylist_file = Path(sys.argv[4])
exception_file = Path(sys.argv[5])
managed_file = Path(sys.argv[6])
report_file = Path(sys.argv[7])
json_file = Path(sys.argv[8])
home_dir = Path.home().resolve()


def normalize_target(raw: str) -> str | None:
    value = raw.strip()
    if not value or value.startswith("#"):
        return None
    if ":" in value:
        value = value.split(":", 1)[0]
    if value.startswith("~/"):
        value = str(home_dir / value[2:])
    path = Path(value).expanduser()
    if path.is_absolute():
        try:
            return path.relative_to(home_dir).as_posix()
        except ValueError:
            return path.as_posix()
    return value.lstrip("./")


def read_targets(path: Path) -> list[str]:
    targets = []
    for raw in path.read_text().splitlines():
        normalized = normalize_target(raw)
        if normalized is not None:
            targets.append(normalized)
    return targets


def read_denylist(path: Path) -> list[str]:
    patterns = []
    for raw in path.read_text().splitlines():
        stripped = raw.strip()
        if stripped and not stripped.startswith("#"):
            patterns.append(stripped)
    return patterns


def read_exceptions(path: Path) -> dict[str, str]:
    exceptions: dict[str, str] = {}
    for raw in path.read_text().splitlines():
        stripped = raw.strip()
        if not stripped or stripped.startswith("#"):
            continue
        parts = stripped.split("\t", 1)
        target = normalize_target(parts[0])
        if target is None:
            continue
        reason = parts[1].strip() if len(parts) > 1 else "intentional exception"
        exceptions[target] = reason
    return exceptions


def read_managed(path: Path) -> list[str]:
    data = json.loads(path.read_text())
    if isinstance(data, list):
        items = data
    else:
        items = data.get("entries", []) if isinstance(data, dict) else []

    managed = []
    for item in items:
        candidate = None
        if isinstance(item, str):
            candidate = item
        elif isinstance(item, dict):
            for key in ("targetPath", "destination", "path", "target", "name"):
                if isinstance(item.get(key), str):
                    candidate = item[key]
                    break
        if candidate is None:
            continue
        normalized = normalize_target(candidate)
        if normalized is not None:
            managed.append(normalized)
    return managed


def ordered_unique(values: list[str]) -> list[str]:
    return sorted(set(values))


def matches_any(target: str, patterns: list[str]) -> bool:
    path = Path(target)
    return any(path.match(pattern) for pattern in patterns)


baseline_targets = ordered_unique(read_targets(baseline_file))
import_targets = ordered_unique(read_targets(import_targets_file))
denylist_patterns = read_denylist(denylist_file)
exception_reasons = read_exceptions(exception_file)
managed_targets = ordered_unique(read_managed(managed_file))


def filter_targets(values: list[str]) -> list[str]:
    return ordered_unique([
        target for target in values
        if not matches_any(target, denylist_patterns)
        and target not in exception_reasons
        and not target.startswith(".migration/")
    ])


filtered_baseline = filter_targets(baseline_targets)
filtered_imports = filter_targets(import_targets)
filtered_managed = filter_targets(managed_targets)

unexpected_mismatches = []
for target in sorted(set(filtered_baseline) - set(filtered_imports)):
    unexpected_mismatches.append({
        "type": "baseline_missing_from_import_contract",
        "target": target,
        "message": f"baseline target missing from import contract: {target}",
    })
for target in sorted(set(filtered_imports) - set(filtered_baseline)):
    unexpected_mismatches.append({
        "type": "import_contract_missing_from_baseline",
        "target": target,
        "message": f"import contract target missing from baseline: {target}",
    })
for target in sorted(set(filtered_imports) - set(filtered_managed)):
    unexpected_mismatches.append({
        "type": "managed_missing_from_chezmoi_output",
        "target": target,
        "message": f"managed target missing from chezmoi output: {target}",
    })
for target in sorted(set(filtered_managed) - set(filtered_imports)):
    unexpected_mismatches.append({
        "type": "chezmoi_manages_unexpected_target",
        "target": target,
        "message": f"chezmoi manages unexpected target: {target}",
    })

intentional_exceptions = []
for target, reason in sorted(exception_reasons.items()):
    if target in baseline_targets or target in import_targets or target in managed_targets:
        intentional_exceptions.append({"target": target, "reason": reason})

if unexpected_mismatches:
    status = "failed"
elif intentional_exceptions:
    status = "exceptions_only"
else:
    status = "clean"

report_lines = [
    "# Chezmoi Post-Apply Report",
    "",
    f"- Repo root: `{repo_root}`",
    f"- Baseline file: `{baseline_file}`",
    f"- Managed artifact: `{managed_file}`",
    f"- JSON artifact: `{json_file}`",
    "",
    "## Post-apply parity summary",
    "",
    f"- Status: `{status}`",
    f"- Baseline targets in scope: `{len(filtered_baseline)}`",
    f"- Import-contract targets in scope: `{len(filtered_imports)}`",
    f"- Chezmoi managed targets in scope: `{len(filtered_managed)}`",
    f"- Unexpected mismatches: `{len(unexpected_mismatches)}`",
    f"- Intentional exceptions: `{len(intentional_exceptions)}`",
    "",
    "## Intentional exceptions",
    "",
]

if intentional_exceptions:
    report_lines.extend([
        f"- `{entry['target']}` - {entry['reason']}" for entry in intentional_exceptions
    ])
else:
    report_lines.append("- None")

report_lines.extend([
    "",
    "## Unexpected mismatches",
    "",
])

if unexpected_mismatches:
    report_lines.extend([f"- {entry['message']}" for entry in unexpected_mismatches])
else:
    report_lines.append("- None")

report_lines.extend([
    "",
    "## Managed target counts",
    "",
    f"- Baseline targets after filtering: `{len(filtered_baseline)}`",
    f"- Import-contract targets after filtering: `{len(filtered_imports)}`",
    f"- Chezmoi managed targets after filtering: `{len(filtered_managed)}`",
    "",
])

report_file.write_text("\n".join(report_lines))

json_file.write_text(json.dumps({
    "status": status,
    "intentional_exceptions": intentional_exceptions,
    "unexpected_mismatches": unexpected_mismatches,
    "baseline_targets": filtered_baseline,
    "import_targets": filtered_imports,
    "managed_targets": filtered_managed,
}, indent=2) + "\n")

sys.exit(1 if unexpected_mismatches else 0)
PY
