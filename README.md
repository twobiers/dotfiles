# Dotfiles

My dotfiles using [chezmoi](https://github.com/twpayne/chezmoi)

## Repository Layout

All managed dotfiles live under `home/` — the chezmoi source root is set to that directory via `.chezmoiroot`. The repo root itself only holds meta-files (`README.md`, `CLAUDE.md`, `install.sh`, `test-vm.sh`, `.chezmoiroot`).

## Prerequisites

- **OS**: Linux (Ubuntu or Debian-based with GNOME)
- **chezmoi**: Install via the official one-liner:
  ```sh
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin
  export PATH="$HOME/.local/bin:$PATH"
  ```
- **Proton Pass**: The "Personal" vault must be accessible — secrets are pulled from it during setup


## Maintenance

### Remove unmanaged files from zsh config

```bash
chezmoi unmanaged ~/.config/zsh | grep -Ev '\.zcompdump|\.zsh_history' | sed "s|^|$HOME/|" | xargs rm
```

### Test on my lovely VirtualBox instance

```bash
./test-vm.sh
```
