# Import-Module posh-git
# Import-Module oh-my-posh
# Set-Theme Paradox
# oh-my-posh --init --shell pwsh --config "~/iterm3.omp.json" | Invoke-Expression

function Invoke-Starship-PreCommand {
    $loc = $($executionContext.SessionState.Path.CurrentLocation);
    $prompt = "$([char]27)]9;12$([char]7)"
    if ($loc.Provider.Name -eq "FileSystem")
    {
      $prompt += "$([char]27)]9;9;`"$($loc.Path)`"$([char]7)"
    }
    $host.ui.Write($prompt)
}

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
$completions = @("chezmoi", "dotnet", "kubectl", "choco")
foreach ($script in $completions) {
    . $HOME/.config/powershell/completions/$script.ps1
}

# Chezmoi Env Vars
$env:SHELL = "pwsh -NoLogo"
$env:EDITOR = "code"