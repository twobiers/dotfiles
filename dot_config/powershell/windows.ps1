#Requires -RunAsAdministrator

Write-Host "Configuring Explorer..." -ForegroundColor "Yellow"

# Explorer: Show hidden files by default: Show Files: 1, Hide Files: 2
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Hidden" 1

# Explorer: Show file extensions by default
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideFileExt" 0

Write-Host "Configuring Taskbar..." -ForegroundColor "Yellow"

# Taskbar left aligned
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarAl" 0

# Hide Widget Icon
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarDa" 0

Write-Host "Other Tweaks..." -ForegroundColor "Yellow"

# Disable Web Search
Set-ItemProperty "HKCU:\Software\Policies\Microsoft\Windows" "DisableSearchBoxSuggestions" 1

# Let me directly login instead of showing a picture and hitting a button
Set-ItemProperty "HKCU:\Software\Policies\Microsoft\Windows" "NoLockScreen" 1

# Show me what is happening on boot and reboot
Set-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" "verbosestatus" 1

# Bring back old Context Menu
# Set-ItemProperty "HKCU:\Software\Classes\CLSID" "InprocServer32" "{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}"

# Disable OneDrive Context
Set-ItemProperty "HKCU:\Software\Classes\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" "System.IsPinnedToNameSpaceTree" 0