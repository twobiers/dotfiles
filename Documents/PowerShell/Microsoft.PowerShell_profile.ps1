# Import-Module posh-git
# Import-Module oh-my-posh
# Set-Theme Paradox
# oh-my-posh --init --shell pwsh --config "~/iterm3.omp.json" | Invoke-Expression

if ($host.name -eq "ConsoleHost") {
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

    try {
        if(Get-Command zoxide) {
            Invoke-Expression (& {
                $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
                (zoxide init --hook $hook powershell | Out-String)
            })            
        }
    }
    Catch {
        Write-Host "zoxide not installed"
    }

    $modules = @("Microsoft.PowerShell.TextUtility", "PSFzf", "Terminal-Icons", "PSReadLine")

    foreach ($mod in $modules) {
        try {
            Import-Module $mod

            if($mod -eq "PSFzf") {
            # Don't replace tab completion for the moment. I don't like it. PSReadline works like a charm for me
            #    Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
                Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
            }
        } catch {
            Write-Host "Module $mod is not installed, run";
            Write-Host -ForegroundColor yellow "Install-Module -Name $mod -AllowPrerelease"
            Write-Host "to install"
        }
    }

    # Register Aliases
    . $HOME/.config/powershell/aliases.ps1

    # Register Autocompletions
    $completions = @("chezmoi", "dotnet", "kubectl", "choco", "kubefwd", "docker", "zoxide")
    foreach ($script in $completions) {
        if(Get-Command $script -ErrorAction SilentlyContinue) {
            . $HOME/.config/powershell/completions/$script.ps1
        } else {
            Write-Host -ForegroundColor Yellow "Could not find $script installed, but a completion script is registered. Skipping it...."
        }
    }

    $env:SHELL = "pwsh" # Fzf does not like the '-NoLogo' option
    $env:EDITOR = "code --wait"
}