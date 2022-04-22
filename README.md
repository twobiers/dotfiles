# Dotfiles

My dotfiles using [chezmoi](https://github.com/twpayne/chezmoi)

## Notes (install.ps1)

- git will add gpg to the path and since we need GPG4Win on it, the priroitization needs to be changed, verify using `Get-Command gpg`
- import gpg secret using `gpg --import privkey.sec`
- Peace needs to be manually installed