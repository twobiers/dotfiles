if (Get-Command docker -ErrorAction SilentlyContinue) {
    Set-Alias -Name d -Value docker -Option ReadOnly
}