# Test file for the Vester module - https://github.com/WahlNetwork/Vester
# Called via Invoke-Pester VesterTemplate.Tests.ps1

# Test title, e.g. 'DNS Servers'
$Title = 'Validate DRS VM Rules'

# Test description: How New-VesterConfig explains this value to the user
$Description = 'Validate existence and configuration of DRS VM Rules'

# The config entry stating the desired values
[ScriptBlock]$Desired = {
    #Builds a string array of group|membername for comparison with actual
    $tmpDesired = @()
    foreach ($rule in $cfg.cluster.drsVMRules) {
        foreach ($vmid in $rule.VMIds) {
            $tmpDesired += ($rule.name+"|"+$rule.type+"|"+$rule.enabled+"|"+$vmid).ToLower()
        }
    }
    $tmpDesired
}
# The test value's data type, to help with conversion: bool/string/int
$Type = 'string[]'
# The command(s) to pull the actual value for comparison
# $Object will scope to the folder this test is in (Cluster, Host, etc.)
[ScriptBlock]$Actual = {
   # [string[]]
    $tmpActual = @()
    $rules = Get-DrsRule -Cluster $object
    foreach ($rule in $rules) {
        foreach ($vmid in $rule.VMIds) {
            $tmpActual += ($rule.name+"|"+$rule.type+"|"+$rule.enabled+"|"+$vmid).ToLower()
        }
    }
    $tmpActual
}
#>
# The command(s) to match the environment to the config
# Use $Object to help filter, and $Desired to set the correct value
[ScriptBlock]$Fix = {
    #Coming Soon
    <#
    $clusterview = Get-Cluster -Name $Object | Get-View
    $clusterspec = New-Object -TypeName VMware.Vim.ClusterConfigSpecEx
    $clusterspec.proactiveDrsConfig = New-Object -TypeName VMware.Vim.ClusterProactiveDrsConfigInfo
    $clusterspec.proactiveDrsConfig.enabled = $Desired
    $clusterview.ReconfigureComputeResource_Task($clusterspec, $true)    
    #>
}
