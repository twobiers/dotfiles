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
if ($null -eq (Get-Command cinst -ErrorAction SilentlyContinue | Select-Object Definition)) {
    Invoke-Expression (new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')
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
choco install keepassxc --limit-output
choco install everything --limit-output

choco install adobereader --limit-output
choco install firefox --limit-output
choco install googledrive --limit-output

choco install discord --limit-output
choco install discord-canary --limit-output

choco install jetbrainstoolbox --limit-output

choco install starship --limit-output

# GPG
choco install gpg4win --limit-output

# Java Tooling
choco install temurin --limit-output
choco install gradle --limit-output
choco install maven --limit-output

# .NET Tooling
choco install dotnet --limit-output

# Rust Tooling
choco install rustup.install --limit-output

# Node Tooling
choco install nvm --limit-output
choco install nodejs --limit-output

# AWS
choco install aws-vault --limit-output
choco install awscli --limit-output
choco install kubernetes-kops --limit-output

# Sound
# TODO: Peace needs to be installed manually
# TODO: APO needs to be installed for devices
# TODO: Config needs to be applied manually
choco install equalizerapo --limit-output

choco install zoom --limit-output


Write-Host "Installing winget..." -ForegroundColor "Yellow"
$hasPackageManager = Get-AppPackage -name 'Microsoft.DesktopAppInstaller'
if (!$hasPackageManager -or [version]$hasPackageManager.Version -lt [version]"1.10.0.0") {
    Add-AppxPackage -Path 'https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx'

    $releases_url = 'https://api.github.com/repos/microsoft/winget-cli/releases/latest'

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $releases = Invoke-RestMethod -uri $releases_url
    $latestRelease = $releases.assets | Where-Object { $_.browser_download_url.EndsWith('msixbundle') } | Select-Object -First 1

    "Installing winget from $($latestRelease.browser_download_url)"
    Add-AppxPackage -Path $latestRelease.browser_download_url
}

Write-Host "Installing winget packages..." -ForegroundColor "Yellow"
winget install Microsoft.PowerToys --source winget --silent --accept-package-agreements  --accept-source-agreements
winget install Microsoft.WindowsTerminal.Preview --source winget --silent --accept-package-agreements  --accept-source-agreements
winget install microsoft.powershell --silent --accept-package-agreements  --accept-source-agreements
winget install Microsoft.Teams --silent --accept-package-agreements  --accept-source-agreements

Write-Host "Installing fonts..." -ForegroundColor "Yellow"
$Uri = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
$Location = "$HOME\Downloads\JetbrainsMono.zip"
Invoke-WebRequest -Uri $Uri -OutFile $Location
$DestinationPath = "$HOME\Downloads\JetBrainsMono"
Expand-Archive -Path $Location -DestinationPath $DestinationPath -Force
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

################
# SSH / GPG Settings
################
$pageantDir = "C:\tools\wsl-ssh-pageant"
$pageantPath = "$pageantDir\wsl-ssh-pageant-amd64-gui.exe"
$pageantSockPath = "$pageantDir\wsl-ssh-agent.sock"
$pageantPipeName = "winssh-pageant"
$autostartDir = "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
If(!(Test-Path $pageantDir)) {
	New-Item -ItemType Directory -Force -Path $pageantDir
}
Invoke-WebRequest -Uri "https://github.com/benpye/wsl-ssh-pageant/releases/download/20201121.2/wsl-ssh-pageant-amd64-gui.exe" -OutFile $pageantPath
$Shortcut = $WshShell.CreateShortcut("$autostartDir\start-wsl-pageant.lnk")
$Shortcut.TargetPath = $pageantPath
$Shortcut.Arguments = "-force -systray -verbose -wsl $pageantSockPath -winssh $pageantPipeName"
$Shortcut.Save()
[Environment]::SetEnvironmentVariable("GIT_SSH", "C:\Windows\system32\OpenSSH\ssh.exe", 'Machine')
[Environment]::SetEnvironmentVariable("SSH_AUTH_SOCK", "\\.\pipe\$pageantPipeName", 'Machine')

Write-Output "PowerShell.exe -WindowStyle Hidden -Command 'gpg-connect-agent /bye'" | Out-File "$autostartDir/start-gpg-connect-agent.bat"

################

$decision = $Host.UI.PromptForChoice("Install", "Base instllation finished, do you also want to apply windows defaults?", @('&Yes', '&No'), 1)
if ($decision -eq 0) {
    . ./windows.ps1
}