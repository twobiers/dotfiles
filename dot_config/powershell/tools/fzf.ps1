if(Get-Command Invoke-Fzf -ErrorAction SilentlyContinue) {
    Set-Alias -Name fzf -Value Invoke-Fzf -Option ReadOnly
}