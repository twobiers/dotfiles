# Hashes of fonts:
# {{ include ".local/share/fonts/Jetbrains Mono NF Regular.ttf" | sha256sum }}
# {{ include ".local/share/fonts/Jetbrains Mono NF Bold.ttf" | sha256sum }}
# {{ include ".local/share/fonts/Jetbrains Mono NF Italic.ttf" | sha256sum }}
# {{ include ".local/share/fonts/Jetbrains Mono NF BoldItalic.ttf" | sha256sum }}
# TOOD: Hash the whole directory

# Based on this gist: https://gist.github.com/anthonyeden/0088b07de8951403a643a8485af2709b?permalink_comment_id=3651336#gistcomment-3651336

$Source = ".local/share/fonts"
$Destination = (New-Object -ComObject Shell.Application).Namespace(0x14)
$TempFolder = "C:\Windows\Temp\Fonts"

New-Item $TempFolder -Type Directory -Force | Out-Null

Get-ChildItem -Path $Source -Include '*.ttf', '*.ttc', '*.otf' -Recurse | ForEach-Object {
  If (-not(Test-Path "C:\Windows\Fonts\$($_.Name)")) {

    $Font = "$TempFolder\$($_.Name)"

    # Copy font to local temporary folder
    Copy-Item $($_.FullName) -Destination $TempFolder

    # Install font
    $Destination.CopyHere($Font, 0x10)

    # Delete temporary copy of font
    Remove-Item $Font -Force
  }
}
