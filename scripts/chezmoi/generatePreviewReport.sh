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
REPORT_FILE="$STATE_DIR/chezmoi-preview-report.md"

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

python3 - "$REPO_ROOT" "$BASELINE_FILE" "$IMPORT_TARGETS_FILE" "$DENYLIST_FILE" "$EXCEPTION_FILE" "$MANAGED_FILE" "$REPORT_FILE" <<'PY'
import json
import shlex
import sys
from pathlib import Path


repo_root = Path(sys.argv[1]).resolve()
baseline_file = Path(sys.argv[2])
import_targets_file = Path(sys.argv[3])
denylist_file = Path(sys.argv[4])
exception_file = Path(sys.argv[5])
managed_file = Path(sys.argv[6])
report_file = Path(sys.argv[7])
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

filtered_baseline = ordered_unique([
    target for target in baseline_targets
    if not matches_any(target, denylist_patterns)
    and target not in exception_reasons
    and not target.startswith(".migration/")
])
filtered_imports = ordered_unique([
    target for target in import_targets
    if not matches_any(target, denylist_patterns)
    and target not in exception_reasons
    and not target.startswith(".migration/")
])
filtered_managed = ordered_unique([
    target for target in managed_targets
    if not matches_any(target, denylist_patterns)
    and target not in exception_reasons
    and not target.startswith(".migration/")
])

unexpected_mismatches = []
for target in sorted(set(filtered_baseline) - set(filtered_imports)):
    unexpected_mismatches.append(f"baseline target missing from import contract: {target}")
for target in sorted(set(filtered_imports) - set(filtered_baseline)):
    unexpected_mismatches.append(f"import contract target missing from baseline: {target}")
for target in sorted(set(filtered_imports) - set(filtered_managed)):
    unexpected_mismatches.append(f"managed target missing from chezmoi output: {target}")
for target in sorted(set(filtered_managed) - set(filtered_imports)):
    unexpected_mismatches.append(f"chezmoi manages unexpected target: {target}")

ignore_file = repo_root / "home" / ".chezmoiignore"
rcm_excludes = []
if (repo_root / "rcrc").exists():
    for raw in (repo_root / "rcrc").read_text().splitlines():
        if "EXCLUDES=" not in raw:
            continue
        _, quoted = raw.split("=", 1)
        rcm_excludes.extend(shlex.split(quoted.strip().strip('"')))

if ignore_file.exists():
    for raw in ignore_file.read_text().splitlines():
        stripped = raw.strip()
        if not stripped or stripped.startswith("#"):
            continue
        if stripped in denylist_patterns:
            continue
        if stripped not in rcm_excludes:
            rcm_excludes.append(stripped)

report_lines = [
    "# Chezmoi Preview Report",
    "",
    f"- Repo root: `{repo_root}`",
    f"- Baseline file: `{baseline_file}`",
    f"- Managed artifact: `{managed_file}`",
    "",
    "## Mapped targets",
    "",
]

if import_targets:
    report_lines.extend([f"- `{target}`" for target in import_targets])
else:
    report_lines.append("- None")

report_lines.extend([
    "",
    "## Exclusions carried from rcrc",
    "",
])

if rcm_excludes:
    report_lines.extend([f"- `{pattern}`" for pattern in rcm_excludes])
else:
    report_lines.append("- None")

report_lines.extend([
    "",
    "## Local-only denylist",
    "",
])

if denylist_patterns:
    report_lines.extend([f"- `{pattern}`" for pattern in denylist_patterns])
else:
    report_lines.append("- None")

report_lines.extend([
    "",
    "## Intentional exceptions",
    "",
])

if exception_reasons:
    report_lines.extend([f"- `{target}` — {reason}" for target, reason in sorted(exception_reasons.items())])
else:
    report_lines.append("- None")

report_lines.extend([
    "",
    "## Unexpected mismatches",
    "",
])

if unexpected_mismatches:
    report_lines.extend([f"- {entry}" for entry in unexpected_mismatches])
else:
    report_lines.append("- None")

exception_summary = ", ".join(f"`{target}`" for target in sorted(exception_reasons)) if exception_reasons else "none"
blocking_summary = "yes" if unexpected_mismatches else "no"

report_lines.extend([
    "",
    "## Decision for Phase 3",
    "",
    f"- Intentional exceptions remaining: {exception_summary}.",
    f"- Unexpected mismatches block progress: {blocking_summary}.",
    "- Real apply and cleanup still wait for Phase 3.",
    "",
])

report_file.write_text("\n".join(report_lines))

sys.exit(1 if unexpected_mismatches else 0)
PY
