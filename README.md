# Dotfiles

My dotfiles using [chezmoi](https://github.com/twpayne/chezmoi)

## Maintenance

### Remove unmanaged files from zsh config

```bash
chezmoi unmanaged ~/.config/zsh | grep -Ev '\.zcompdump|\.zsh_history' | sed "s|^|$HOME/|" | xargs rm
```

## Notes (install.ps1)

- git will add gpg to the path and since we need GPG4Win on it, the priroitization needs to be changed, verify using `Get-Command gpg`
- import gpg secret using `gpg --import privkey.sec`
- Peace needs to be manually installed