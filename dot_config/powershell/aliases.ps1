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

${function:chezmoi-cd} = { Set-Location $(chezmoi source-path) }

# Kubernetes
if(Get-Command kubectl -ErrorAction SilentlyContinue) {
    Set-Alias -Name k -Value kubectl -Option ReadOnly
    Set-Alias -Name kctl -Value kubectl -Option ReadOnly
}

# Docker
if(Get-Command docker -ErrorAction SilentlyContinue) {
    Set-Alias -Name d -Value docker -Option ReadOnly
}

# cat -> bat
if (Get-Command bat -ErrorAction SilentlyContinue) {
    Remove-Alias -Name cat -Force
    $bat = "bat"
    $standardArgs = @("--style=plain", "--paging=never")

    function Invoke-Bat {
        if($MyInvocation.ExpectingInput) {
            $input | &$bat $standardArgs $args
        } else {
            &$bat $standardArgs $args
        }
    }
    Set-Alias -Name cat -Value Invoke-Bat -Option ReadOnly
}