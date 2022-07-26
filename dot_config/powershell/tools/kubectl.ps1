if (Get-Command kubectl -ErrorAction SilentlyContinue) {
    Set-Alias -Name k -Value kubectl -Option ReadOnly
    Set-Alias -Name kctl -Value kubectl -Option ReadOnly
}

