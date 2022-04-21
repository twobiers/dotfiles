#Requires -RunAsAdministrator

$decision = $Host.UI.PromptForChoice("Install", "This script is meant to bootstrap a windows environemnt. Are you sure you want to continue?", @('&Yes', '&No'), 1)
if ($decision -ne 0) {
    exit
}

Write-Host "Updating Help..." -ForegroundColor "Yellow"
Update-Help -Force

Write-Host "Installing PowerShell Modules..." -ForegroundColor "Yellow"
Install-Module Posh-Git -Scope CurrentUser -Force

Write-Host "Installing Choco..." -ForegroundColor "Yellow"
if ((Get-Command cinst -ErrorAction SilentlyContinue | Select-Object Definition) -eq $null) {
    iex (new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')
    Refresh-Environment
    choco feature enable -n=allowGlobalConfirmation
}

Write-Host "Installing Choco packages" -ForegroundColor "Yellow"
choco install git.install         --limit-output -params '"/GitAndUnixToolsOnPath /NoShellIntegration"'
choco install gsudo               --limit-output
choco install vscode              --limit-output

Refresh-Environment