---
name: install-ansible-package
description: Adds a new package install role to the dotfiles Ansible setup at ansible/roles/ and registers it in ansible/local_machine.yml. Use when the user asks to install a package via Ansible, add a new tool/CLI/app to the dotfiles, wire up a new role, or provision software through their local_machine playbook.
---

# Install a Package via the Dotfiles Ansible Roles

This dotfiles repo provisions the local machine through `ansible/local_machine.yml`, which composes per-tool roles in `ansible/roles/<role>/`. To add a new package, scaffold a role and register it in the playbook.

## Inputs

- **Package name** (required) — what to install (e.g. `bat`, `claude`, `mintotp`, `alacritty`).
- **Installation reference** (optional) — Homebrew formula URL, official install docs, or a `curl | bash` snippet.

If only a doc/URL is given, read it first to identify the install method (brew, brew cask, tap+brew, curl|bash, pip, etc.).

## Step 1 — Decide: new role or extend `cli_tools`?

- **Many small CLI utilities** that are just `brew install <name>` → append a task to `ansible/roles/cli_tools/tasks/darwin.yml` instead of creating a new role.
- **Standalone tool / app / CLI** with its own concerns (URL installer, tap, defaults, multiple steps) → new role under `ansible/roles/<role_name>/`.

Role name is `snake_case` matching the binary or product (`gemini_cli`, `copilot_cli`, `claude`, `terminal`).

## Step 2 — Pick an install strategy

| Source | Module | Reference role |
|---|---|---|
| Homebrew formula | `community.general.homebrew` | `gemini_cli`, `copilot_cli` |
| Homebrew cask | `community.general.homebrew_cask` | `terminal` (alacritty) |
| Tap + formula | `community.general.homebrew_tap` then `community.general.homebrew` | `opencode` |
| `curl ... \| bash` installer | `ansible.builtin.shell` guarded by a `command -v` check | `claude` |
| pip | `ansible.builtin.pip` via the pyenv shim | `mintotp` |

Prefer Homebrew on Darwin. Only fall back to a `curl | bash` installer when no Homebrew formula exists.

## Step 3 — Scaffold the role

Create files under `ansible/roles/<role_name>/`.

### `tasks/main.yml` — Darwin entrypoint (always)

```yaml
---
- name: <role_name> | darwin entrypoint
  ansible.builtin.import_tasks: darwin.yml
  when: ansible_facts['os_family'] == 'Darwin'

- name: <role_name> | unsupported platform placeholder
  ansible.builtin.debug:
    msg: "<Display name> role currently supports Darwin only."
  when: ansible_facts['os_family'] != 'Darwin'
```

### `tasks/darwin.yml` — pick one variant

**Homebrew formula**

```yaml
---
- name: <role_name> | darwin | install <package>
  community.general.homebrew:
    name: <package>
    state: present
```

**Homebrew cask**

```yaml
---
- name: <role_name> | darwin | install <package>
  community.general.homebrew_cask:
    name: <package>
    state: present
```

**Tap + formula**

```yaml
---
- name: <role_name> | darwin | configure <tap> tap
  community.general.homebrew_tap:
    name: <owner>/<tap>
    state: present

- name: <role_name> | darwin | install <package>
  community.general.homebrew:
    name: <package>
    state: present
```

**`curl | bash` installer** (idempotent, with check-mode preview)

Put `<role_name>_installer_url` and `<role_name>_binary_name` in `defaults/main.yml`, then:

```yaml
---
- name: <role_name> | darwin | check installed binary
  ansible.builtin.command:
    cmd: /bin/sh -c "command -v {{ <role_name>_binary_name }}"
  register: <role_name>_binary
  changed_when: false
  failed_when: false

- name: <role_name> | darwin | preview installer
  ansible.builtin.debug:
    msg: "Check mode: would run curl -fsSL {{ <role_name>_installer_url }} | bash"
  when:
    - ansible_check_mode
    - <role_name>_binary.rc != 0

- name: <role_name> | darwin | install <package>
  ansible.builtin.shell: |
    curl -fsSL "{{ <role_name>_installer_url }}" | bash
  args:
    executable: /bin/bash
  when:
    - not ansible_check_mode
    - <role_name>_binary.rc != 0
```

**pip (single `tasks/main.yml`, no Darwin split needed)**

```yaml
---
- name: <role_name> | install <package>
  ansible.builtin.pip:
    name: "<package>"
    executable: "{{ ansible_env.HOME }}/.pyenv/shims/pip3"
```

### `meta/main.yml` — dependencies

```yaml
---
dependencies:
  - role: homebrew
```

- Homebrew/cask/tap installs → depend on `homebrew`.
- pip installs → depend on `python`.
- Pure `curl | bash` with no brew/python need → `dependencies: []`.

### `defaults/main.yml` — only when variables are needed

Used for installer URLs, binary names, version pins. **Skip the file entirely** when there are no defaults (see `cli_tools`, `copilot_cli`, `gemini_cli`).

## Step 4 — Register the role in `ansible/local_machine.yml`

Append a new entry under `roles:`. Place it next to similar tools and **before** `macos` and `dotfiles` (which are always last). The tag matches the role name.

```yaml
    - role: <role_name>
      tags: [<role_name>]
```

Grouping convention (use judgment based on the package):

- AI / agent CLIs → near `opencode`, `gemini_cli`, `copilot_cli`, `claude`.
- Language runtimes / dev tooling → near `go`, `node`, `python`, `ruby`, `java`, `clojure`, `elixir`, `kubernetes`.
- Editors / IDEs → near `vim`, `emacs`, `vscode`.
- Generic single-formula CLI utilities → consider extending `cli_tools` instead.

## Step 5 — Verify

Confirm before stopping:

- Role directory has `tasks/main.yml` and (if Darwin-split) `tasks/darwin.yml`.
- `meta/main.yml` exists with the right dependency.
- All task names follow `<role_name> | darwin | <action>`.
- Installs are idempotent: `state: present`, or a `command -v` guard for shell installers.
- `ansible/local_machine.yml` has a new `- role: <role_name>` entry with matching `tags: [<role_name>]`, placed before `macos`/`dotfiles`.
- Optionally dry-run from `ansible/`:

```bash
ansible-playbook local_machine.yml --check --tags <role_name>
```

## Quick reference: existing roles by pattern

- Multi-formula brew bag → `ansible/roles/cli_tools/`
- Single brew formula → `ansible/roles/gemini_cli/`, `ansible/roles/copilot_cli/`
- Brew cask → `ansible/roles/terminal/` (alacritty)
- Tap + formula → `ansible/roles/opencode/`
- Curl installer with idempotence guard → `ansible/roles/claude/`
- pip install via pyenv shim → `ansible/roles/mintotp/`
