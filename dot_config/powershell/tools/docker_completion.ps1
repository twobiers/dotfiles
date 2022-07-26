try {
    Import-Module DockerCompletion
} catch {
    Write-Host "Module DockerCompletion is not installed, run";
    Write-Host -ForegroundColor yellow "Install-Module DockerCompletion -Scope CurrentUser"
    Write-Host "to install"
}