[Include('*-*.ps1')]$PSScriptRoot

$myModule = $MyInvocation.MyCommand.ScriptBlock.Module
$ExecutionContext.SessionState.PSVariable.Set($myModule.Name, $myModule)
$myModule.pstypenames.insert(0, $myModule.Name)

Export-ModuleMember -Function *-* -Alias * -Variable $myModule.Name