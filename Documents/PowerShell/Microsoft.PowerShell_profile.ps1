#Requires -Version 7

# Import-Module posh-git
# Import-Module oh-my-posh
# Set-Theme Paradox
# oh-my-posh --init --shell pwsh --config "~/iterm3.omp.json" | Invoke-Expression

function IsInteractiveShell {
    # Test each Arg for match of abbreviated '-NonInteractive' command.
    $NonInteractive = [Environment]::GetCommandLineArgs() | Where-Object { $_ -like '-NonI*' }

    if ([Environment]::UserInteractive -and -not $NonInteractive) {
        # We are in an interactive shell.
        return $true
    }

    return $false
}

if (IsInteractiveShell) {

    Set-PSReadLineOption -PredictionSource HistoryAndPlugin 
    Set-PSReadLineOption -PredictionViewStyle ListView

    $modules = @("Microsoft.PowerShell.TextUtility", "Terminal-Icons", "PSReadLine")

    foreach ($mod in $modules) {
        try {
            Import-Module $mod
        }
        catch {
            Write-Host "Module $mod is not installed, run";
            Write-Host -ForegroundColor yellow "Install-Module -Name $mod -AllowPrerelease"
            Write-Host "to install"
        }
    }

    # Register Aliases
    # . $HOME/.config/powershell/aliases.ps1

    # Register Autocompletions
    $tools = @(
        "bat",
        "chezmoi",
        "choco",
        "docker",
        "dotnet",
        "fzf",
        "kubectl",
        "kubefwd",
        "winget",
        "zoxide",
        "rg",
        "kaf",
        "starship"
    )
    $installedTools = (Get-Command $tools -ErrorAction SilentlyContinue).Name -replace '.exe', ''
    $notAvailable = $tools | Where-Object { $installedTools -NotContains $_ }
    $tools = $tools | Where-Object { $installedTools -Contains $_ }
    $toolsBasePath = "$HOME/.config/powershell/tools"
    foreach ($tool in $tools) {
        $toolPath = "$toolsBasePath/$tool.ps1"
        $toolCompletionPath = "$toolsBasePath/${tool}_completion.ps1"
        if (Test-Path $toolPath) {
            . $toolPath
        }
        if (Test-Path $toolCompletionPath) {
            . $toolCompletionPath
        }
    }

    if ($notAvailable.Count -gt 0) {
        Write-Host -ForegroundColor yellow "The following tools are not available: $notAvailable"
    }
    $env:SHELL = "pwsh" # Fzf does not like the '-NoLogo' option
    $env:EDITOR = "code --wait"
}

$PSDefaultParameterValues['Out-Default:OutVariable'] = '__'