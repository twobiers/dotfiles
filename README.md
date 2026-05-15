# Dotfiles

My dotfiles using [chezmoi](https://github.com/twpayne/chezmoi)

## Maintenance

### Remove unmanaged files from zsh config

```bash
chezmoi unmanaged ~/.config/zsh | grep -Ev '\.zcompdump|\.zsh_history' | sed "s|^|$HOME/|" | xargs rm
```
