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

Write-Host "Installing Choco packages..." -ForegroundColor "Yellow"
choco install chezmoi             --limit-output
choco install git.install         --limit-output -params '"/GitAndUnixToolsOnPath /NoShellIntegration"'
choco install gsudo               --limit-output
choco install vscode              --limit-output
choco install sharex              --limit-output
choco install docker-desktop      --limit-output
choco install kubernetes-cli      --limit-output
choco install spotify             --limit-output

Write-Host "Installing winget..." -ForegroundColor "Yellow"
$hasPackageManager = Get-AppPackage -name 'Microsoft.DesktopAppInstaller'
if (!$hasPackageManager -or [version]$hasPackageManager.Version -lt [version]"1.10.0.0") {
    Add-AppxPackage -Path 'https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx'

    $releases_url = 'https://api.github.com/repos/microsoft/winget-cli/releases/latest'

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $releases = Invoke-RestMethod -uri $releases_url
    $latestRelease = $releases.assets | Where { $_.browser_download_url.EndsWith('msixbundle') } | Select -First 1

    "Installing winget from $($latestRelease.browser_download_url)"
    Add-AppxPackage -Path $latestRelease.browser_download_url
}

Write-Host "Installing winget packages..." -ForegroundColor "Yellow"
winget install Microsoft.PowerToys --source winget
winget install Microsoft.WindowsTerminal.Preview --source winget

Refresh-Environment