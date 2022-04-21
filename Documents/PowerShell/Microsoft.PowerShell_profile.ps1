# Import-Module posh-git
# Import-Module oh-my-posh
# Set-Theme Paradox
# oh-my-posh --init --shell pwsh --config "~/iterm3.omp.json" | Invoke-Expression

try {
    if(Get-Command starship) {
        Invoke-Expression (&starship init powershell)
    }
}
Catch {
    Write-Host "Starship is not installed"
}

# Register Aliases
. $HOME/.config/powershell/aliases.ps1

# Register Autocompletions
$completions = @("chezmoi", "dotnet", "kubectl")
foreach ($script in $completions) {
    . $HOME/.config/powershell/completions/$script.ps1
}

# Chezmoi Env Vars
$env:SHELL = "pwsh -NoLogo"
$env:EDITOR = "code"