Import-Module PSFzf

if (Get-Command Invoke-Fzf -ErrorAction SilentlyContinue) {
    Set-Alias -Name fzf -Value Invoke-Fzf -Option ReadOnly
}

# Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r' -EnableAliasFuzzyEdit -EnableAliasFuzzyHistory -EnableAliasFuzzyKillProcess -EnableAliasFuzzySetLocation -EnableAliasFuzzyGitStatus