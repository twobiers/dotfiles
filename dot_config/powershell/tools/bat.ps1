# cat -> bat
Remove-Alias -Name cat -Force
$bat = "bat"
$standardArgs = @("--style=plain", "--paging=never")

function Invoke-Bat {
    if ($MyInvocation.ExpectingInput) {
        $input | &$bat $standardArgs $args
    }
    else {
        &$bat $standardArgs $args
    }
}
Set-Alias -Name cat -Value Invoke-Bat -Option ReadOnly