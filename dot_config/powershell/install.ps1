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

Write-Host "Installing fonts..." -ForegroundColor "Yellow"
$Uri = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
$Location $Env:Userprofile\Downloads\JetbrainsMono.zip
iwr -Uri $Uri -OutFile $Location
$DestinationPath = "$ENV:USERPROFILE\Downloads\JetBrainsMono"
Expand-Archive -Path $OutputFilename -DestinationPath $DestinationPath -Force
# Based on this gist: https://gist.github.com/anthonyeden/0088b07de8951403a643a8485af2709b?permalink_comment_id=3651336#gistcomment-3651336
foreach($FontFile in Get-ChildItem $OutputFilename -Include '*.ttf','*.ttc','*.otf' -recurse ) {
	$targetPath = Join-Path $SystemFontsPath $FontFile.Name
	if(!(Test-Path -Path $targetPath)) {
		#Extract Font information for Reqistry 
		$ShellFolder = (New-Object -COMObject Shell.Application).Namespace($fontSourceFolder)
		$ShellFile = $ShellFolder.ParseName($FontFile.name)
		$ShellFileType = $ShellFolder.GetDetailsOf($ShellFile, 2)

		#Set the $FontType Variable
		If ($ShellFileType -Like '*TrueType font file*') {$FontType = '(TrueType)'}
			
		#Update Registry and copy font to font directory
		$RegName = $ShellFolder.GetDetailsOf($ShellFile, 21) + ' ' + $FontType
		New-ItemProperty -Name $RegName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -PropertyType string -Value $FontFile.name -Force | out-null
		Copy-item $FontFile.FullName -Destination $SystemFontsPath
	}
}
Remove-Item $OutputFilename
Remove-Item -R $DestinationPath

Refresh-Environment

################ 

$decision = $Host.UI.PromptForChoice("Install", "Base instllation finished, do you also want to apply windows defaults?", @('&Yes', '&No'), 1)
if ($decision -eq 0) {
    . ./windows.ps1
}