# TODO: This is relatively slow
# Note that Starship will be much faster when you create a 
# Windows Defender exclusion: C:\ProgramData\chocolatey\lib\starship\tools\starship.exe
function Invoke-Starship-PreCommand {
    $loc = Get-Location
    $prompt = "$([char]27)]9;12$([char]7)"
    if ($loc.Provider.Name -eq "FileSystem") {
        $prompt += "$([char]27)]9;9;`"$($loc.Path)`"$([char]7)"
    }
    $host.ui.Write($prompt)
}

try {
    if (Get-Command starship) {
        Invoke-Expression (&starship init powershell)
    }
}
Catch {
    Write-Host "Starship is not installed"
}