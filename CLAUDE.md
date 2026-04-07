# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A [chezmoi](https://github.com/twpayne/chezmoi) dotfiles repository managing shell configuration, tools, and system settings across macOS, Linux, and Windows.

## Key Commands

```sh
# Apply all dotfiles to the home directory
chezmoi apply

# Preview what chezmoi would change
chezmoi diff

# Re-run from scratch (bootstrap on a new machine)
sh install.sh

# Add a new file to be managed
chezmoi add ~/.some-config-file

# Edit a managed file
chezmoi edit ~/.some-config-file
```

## Architecture

### chezmoi File Naming Conventions

chezmoi uses filename prefixes/suffixes to control behavior:

| Prefix/Suffix | Meaning |
|---|---|
| `dot_` | Becomes `.` in the home directory (e.g., `dot_zshrc` → `~/.zshrc`) |
| `.tmpl` suffix | Processed as a Go template before writing |
| `executable_` | File is marked executable |
| `private_` | File permissions set to 0600 |
| `encrypted_` | File encrypted with age |
| `.age` suffix | Encrypted with age (key at `~/.config/age/key-chezmoi.txt`) |

### Template Data

`.chezmoi.toml.tmpl` detects CPU cores/threads and memory at init time, storing them under `.data.cpu` and `.data.memory`. Templates also have access to `.chezmoi.os`, `.chezmoi.hostname`, and `.chezmoi.homeDir`.

### Cross-Platform Conditionals

Templates gate configs by OS using `{{ if eq .chezmoi.os "darwin" }}` / `"linux"` / `"windows"`. The `.chezmoiignore` file also conditionally excludes files when tools aren't present (e.g., skips `.kube/**` if `kubectl` isn't installed).

### External Resources

`.chezmoiexternal.toml` pulls external assets (fonts, zsh plugins, kubectl helpers) on a weekly `refreshPeriod`. Managed externals: JetBrains Mono Nerd Font, zsh-snap, fubectl.

### ZSH Configuration Structure

`dot_config/zsh/rc.d/` contains numbered scripts loaded in order:

- `01-` history, `03-` znap plugin manager, `04-` env/PATH (templated), `05-` plugins & atuin
- `06-` SSH (templated), `07-` opts, `08-` aliases (heavy kubectl aliasing), `09-` keybindings (templated)
- `10-` chezmoi integration, `11-18` tool-specific setups (direnv, fzf, zoxide, etc.)
- `19-25` language/platform runtimes (k8s, rust, go, java, docker, azure)
- `99-` starship prompt

### Encryption

Secrets use [age](https://age-encryption.org/) encryption. The identity key is at `~/.config/age/key-chezmoi.txt`. Encrypted files have both `encrypted_` prefix and `.age` suffix.

### Git Config

`dot_gitconfig.tmpl` uses directory-based `includeIf` to switch git author identity depending on which project directory you're in (personal vs. work repos). SSH signing is used on most machines; GPG on `tobi-endeavouros`.
