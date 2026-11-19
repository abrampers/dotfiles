# Plan: one Emacs server with per-project Go, Node and Java environments

Status: **approved for implementation, not started** (except step 1, drafted and uncommitted on branch `feat/direnv-role`).

## Problem

Each project currently runs in its own Emacs process (`gvm use …` in a terminal, then `emacs .`), so each Emacs inherits that terminal's Go/Node/Java environment. Side effects:

- Several Emacs processes rewrite Projectile's shared `~/.emacs.d/var/projectile/known-projects.el`. Emacs locks the file during each write, so overlapping writes trigger `error in process sentinel: …/known-projects.el: user@host (pid N)`. Projectile 2.8 (our pinned `002e527`) makes this frequent by saving on every `buffer-list-update-hook`; upstream reverted that in 2.9.0.
- Every process starts its own Copilot Node agent and LSP servers, so memory use multiplies.

Goal: a single Emacs server where every project buffer automatically gets the right Go (gvm), Node (nvm) and JDK environment.

## Decisions (from the interview)

| Topic | Decision |
|---|---|
| Go version | From `go.mod`: a `toolchain` line means that exact version; otherwise the highest installed patch of the `go` line's minor version (`go 1.26.0` → `go1.26.5`) |
| Go pkgset | One per repo, named after the repo's `origin` remote (falling back to the directory name), created automatically. Clones of the same repo share it (`go1.26.5@merchant-listing-service`) |
| Go module cache | One shared `GOMODCACHE` for all pkgsets and Go versions |
| Go tools | gopls and goimports installed into each pkgset |
| Node | The repo's `.nvmrc` |
| JDK | 8 by default; an untracked `.java-version` overrides it |
| Version not installed | Error with a `Next:` command; installing only happens when you run `abram/toolchain-install` |
| Mechanism | direnv + `envrc.el`, with a git-ignored `.envrc` per repo |
| `.envrc` creation | Only by explicit command (`abram/envrc-init` / `envrc-init`) |
| Version changes | Manual reload (`abram/env-reload`) |
| Server start | launchd at login (`brew services` for emacs-plus@30) |
| Opening projects | `ec .` from a terminal, or Projectile switch inside Emacs |
| Terminal | direnv zsh hook enabled, so `cd` into a repo switches versions too |
| Copilot's Node | Pinned to the newest nvm Node, independent of projects |
| Git ignore | `.envrc`, `.direnv/`, `.java-version` in the global ignore, managed by chezmoi |
| Environment needed by | LSP servers and compile/test/format (also applies to CIDER and vterm started from a project buffer) |

## Workflow after the change

**At login.** launchd runs `emacs --fg-daemon`. Emacs.app is no longer started by hand.

**First time in a repo (once per repo).**

```sh
cd ~/Code/source.golabs.io/go-food/merchant-listing-service
envrc-init            # or M-x abram/envrc-init inside Emacs
```

This writes a git-ignored `.envrc` based on what the repo contains, then runs `direnv allow`:

```bash
use gvm_project      # go.mod present
use nvm_project      # .nvmrc present
use jdk_project      # project.clj / deps.edn / pom.xml / build.gradle present
```

The first Go load creates pkgset `go1.26.5@merchant-listing-service`. Opening a `.go` file when the pkgset has no gopls installs gopls and goimports in the background (`*go-tools-install*`), then starts LSP.

**Every day.**

- `ec .` from any terminal opens a new frame of the one server on that directory. `C-c p p` works inside Emacs as before.
- Each buffer automatically gets its project's environment. A Go 1.21 repo, a Go 1.26 repo, `gofood-web-service` on Node 24 and `cashier` on JDK 8 can be open at the same time.
- Each project gets its own gopls / typescript-language-server / clojure-lsp process with its own environment (verified: none of these lsp-mode clients is multi-root).
- `M-x compile`, `projectile-test-project`, goimports on save and `cider-jack-in` run with the buffer's environment (verified: go-mode runs goimports via `process-file` in the source buffer).
- In a terminal, `cd` into the repo switches Go/Node/JDK the same way.

**After changing a version** (bump `go.mod`, edit `.nvmrc`, `echo 11 > .java-version`): `M-x abram/env-reload` re-runs direnv for the project and restarts its LSP servers.

**When a version isn't installed:** the error ends with `Next: M-x abram/toolchain-install`. That command installs what's missing and reloads the project.

**Buffers outside a project** (`*scratch*`, stray files) use the server's default environment from exec-path-from-shell.

**Projectile lock error** disappears, because only one process writes `known-projects.el`.

## Error messages: always say the next step

Every failure ends with one `Next:` line.

| Situation | Message ends with |
|---|---|
| Go/Node/JDK version not installed | `Next: M-x abram/toolchain-install (terminal: toolchain-install)` |
| Repo has no `.envrc` | `Next: M-x abram/envrc-init (terminal: envrc-init)` |
| `.envrc` not yet allowed, or changed | `Next: M-x envrc-allow (terminal: direnv allow)` |
| `go.mod` / `.nvmrc` / `.java-version` changed | `Next: M-x abram/env-reload` |
| gopls/goimports install into the pkgset failed | `See *go-tools-install*. Next: M-x abram/go-install-tools` |
| Toolchain install failed | `See *toolchain-install*.` plus the exact command it ran |
| Pkgset creation failed | The exact `gvm pkgset create …` command to run |

In Emacs these appear in the echo area, with the full direnv log in `*envrc*`. To verify during implementation: how `envrc.el` surfaces direnv errors. If the `Next:` line doesn't reach the echo area by default, add a small hook that shows it.

## Install command: `abram/toolchain-install` / `toolchain-install`

Both call one script, `home/dot_scripts/executable_toolchain-install`, so the terminal and Emacs behave the same.

1. Read the project's `go.mod`, `.nvmrc` and `.java-version` (or the JDK 8 default) and find what's missing.
2. Install only the missing pieces, with output in `*toolchain-install*`:
   - Go: `gvm install go<minor>.<highest patch from gvm listall> -B`, or the exact `toolchain` version.
   - Node: `nvm install <.nvmrc>`.
   - JDK: `brew install --cask temurin@<v>`.
3. On success, run `abram/env-reload` automatically (in Emacs).

Go versions before 1.16 have no Apple Silicon build (see Risks). The script detects this and explains it instead of failing with a confusing error.

## Implementation steps

1. **Ansible: install direnv.** `ansible/roles/direnv/` (homebrew `direnv`, same pattern as the `gh` role) and an entry in `ansible/local_machine.yml`. *Drafted, uncommitted; syntax check and check-mode run pass.*
2. **Ansible `emacs` role: start the server at login.** Start the `emacs-plus@30` brew service (`emacs --fg-daemon`, keep-alive).
3. **chezmoi `home/dot_config/direnv/direnvrc`:**
   - `use_gvm_project`: `watch_file go.mod`, resolve the Go version as above, pkgset named after the repo, create it if missing, `gvm use`, set the shared `GOMODCACHE`.
   - `use_nvm_project`: `nvm which "$(cat .nvmrc)"`, add that Node to `PATH`.
   - `use_jdk_project`: `.java-version` or 8 (8 → `1.8`), `java_home -F -v <v>` with an empty-output check, set `JAVA_HOME`, add `$JAVA_HOME/bin` to `PATH`.
   - Every error goes through `log_error` with a `Next:` line.
4. **chezmoi `home/dot_config/git/ignore`:** keep the existing `**/.claude/settings.local.json` line; add `.envrc`, `.direnv/`, `.java-version`.
5. **chezmoi zsh:**
   - `home/dot_zsh/functions.zsh`: `ec` (`emacsclient -c -n -a '' "${@:-.}"`), `envrc-init`, `toolchain-install`.
   - `home/dot_zshrc`: `eval "$(direnv hook zsh)"` after the gvm/nvm setup.
   - `home/dot_scripts/executable_toolchain-install`.
6. **Emacs `config.org`.** First reconcile `~/.emacs.d/config.org` with `home/dot_emacs.d/config.org` (they currently differ). Then:
   - Add `envrc` (with `envrc-global-mode` turned on last in the config).
   - Go: remove the fixed `lsp-go-gopls-server-path` that is computed once at startup. Replace the `go-mode → lsp-deferred` hook with one that installs missing tools into the pkgset (`GOTOOLCHAIN=auto go install …`, run from the source buffer so it uses the project's environment) and then starts LSP. Avoid duplicate installs for the same pkgset.
   - Set `copilot-node-executable` to the newest nvm Node.
   - Add `abram/envrc-init`, `abram/env-reload` (`envrc-reload`, then restart the project's LSP workspaces), `abram/toolchain-install`, `abram/go-install-tools`.
   - Show direnv `Next:` lines in the echo area if `envrc.el` doesn't already.
   - Keep exec-path-from-shell for the server's default environment.
7. **Migration.** Close the current Emacs instances, start the brew service, run `envrc-init` in the active repos.

Each step is implemented and reviewed separately on `feat/direnv-role`.

## Verification

- **Terminal:** `cd` into `gfs`, `merchant-listing-service`, `gofood-web-service`, `cashier`; check `go version`, `go env GOPATH GOMODCACHE`, `node -v`, `java -version`.
- **Emacs, two Go versions:** open two Go repos on different Go versions in one session. In each Go buffer check `M-: (getenv "GOROOT")`. Confirm `lsp-describe-session` shows two gopls processes with different binaries.
- **Tools:** goimports-on-save uses the pkgset's binary; Copilot runs on the pinned Node; `cider-jack-in` in `cashier` gets JDK 8.
- **Errors:** remove a version / point `.nvmrc` at an uninstalled version and confirm the `Next:` line appears; run `abram/toolchain-install` and confirm it installs and reloads.
- **Lock error:** no `known-projects.el` error after a day of use.

Resolution logic already tested against the real installs:

- Go: `merchant-listing-service → go1.26.5`, `buffet → go1.24.5`, `gfs → go1.21.13`, `shuffle-card-adapter → go1.22.12`; `kvstore-client-go` (`go 1.14`) correctly errors.
- Node: `.nvmrc` `v24.3.0` resolves; `20` correctly errors.
- JDK: plain `java_home -v 17` silently returns JDK 21 with exit 0; `java_home -F -v` plus an empty-output check catches it. JDK 8 must be requested as `1.8`.

## Risks and open items

- **gopls on old Go.** `gopls@latest` won't build with Go 1.21, so build it with `GOTOOLCHAIN=auto`. If recent gopls doesn't handle very old projects, add a table pinning a gopls version per Go minor version.
- **Go 1.14 on Apple Silicon.** `kvstore-client-go` needs Go 1.14, which has no darwin/arm64 build (arm64 starts at 1.16). Options when we get there: an amd64 Go under Rosetta, or a newer Go for that repo via an override file.
- **Speed.** Loading gvm/nvm inside direnv may make a project's first load roughly 0.5–1 s slower. `envrc.el` caches per directory afterwards.
- **No locked patch versions.** Installing a newer patch (e.g. `go1.26.6`) changes which Go a repo uses at its next reload.
- **Non-project buffers** use the server's default environment, which has no gvm Go (gvm has no default set); they fall back to `/opt/homebrew/bin/go`.
