# Easier Navigation: .., ..., ...., ....., and ~
${function:~} = { Set-Location ~ }
# PoSh won't allow ${function:..} because of an invalid path error, so...
${function:Set-ParentLocation} = { Set-Location .. }; Set-Alias ".." Set-ParentLocation
${function:...} = { Set-Location ..\.. }
${function:....} = { Set-Location ..\..\.. }
${function:.....} = { Set-Location ..\..\..\.. }
${function:......} = { Set-Location ..\..\..\..\.. }

# Navigation Shortcuts
${function:drop} = { Set-Location ~\Documents\Dropbox }
${function:dt} = { Set-Location ~\Desktop }
${function:docs} = { Set-Location ~\Documents }
${function:dl} = { Set-Location ~\Downloads }
${function:prj} = { Set-Location P: }

# Kubernetes
if(Get-Command kubectl -ErrorAction SilentlyContinue) {
    Set-Alias -Name k -Value kubectl -Option ReadOnly
    Set-Alias -Name kctl -Value kubectl -Option ReadOnly
}

# cat -> bat
if (Get-Command bat -ErrorAction SilentlyContinue) {
    if((Get-Alias -Name cat).Definition -ne "Invoke-Bat") {
        Remove-Alias -Name cat -Force
        $bat = bat --style=plain --paging=never
        function Invoke-Bat {
            if($MyInvocation.ExpectingInput) {
                $input | & $bat
            } else {
                & $bat $args
            }
        }
        Set-Alias -Name cat -Value Invoke-Bat -Option ReadOnly
    }
}