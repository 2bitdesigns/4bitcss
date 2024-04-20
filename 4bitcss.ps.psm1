[Include('*-*.ps1')]$PSScriptRoot

$myModule = $MyInvocation.MyCommand.ScriptBlock.Module
$ExecutionContext.SessionState.PSVariable.Set($myModule.Name, $myModule)
$myModule.pstypenames.insert(0, $myModule.Name)

$newDriveSplat = @{PSProvider='FileSystem';ErrorAction='Ignore';Scope='Global'}
New-PSDrive -Name $MyModule.Name -Root ($MyModule | Split-Path) @newDriveSplat

if ($home) {
    $myMyModule = "My$($myModule.Name)"
    $myMyModuleRoot = Join-Path $home $myMyModule
    if (Test-Path $myMyModuleRoot) {
        New-PSDrive -Name $myMyModule -Root $myMyModuleRoot @newDriveSplat
    }
}

Export-ModuleMember -Function *-* -Alias * -Variable $myModule.Name