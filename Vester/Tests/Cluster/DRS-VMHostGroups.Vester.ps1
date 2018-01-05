# Test file for the Vester module - https://github.com/WahlNetwork/Vester
# Called via Invoke-Pester VesterTemplate.Tests.ps1

# Test title, e.g. 'DNS Servers'
$Title = 'Validate DRS VMHost groups'

# Test description: How New-VesterConfig explains this value to the user
$Description = 'Validate existence and membership of DRS Host Groups'

# The config entry stating the desired values
[ScriptBlock]$Desired = {
    #Builds a string array of group|membername for comparison with actual
    $tmpDesired = @()
    if( $cfg.cluster.drsVMHostGroups.length -ge 1) {
        foreach ($group in $cfg.cluster.drsVMHostGroups) {
            #Want to account for existence of empty groups as well
            $tmpDesired += ($group.name).ToLower()
            foreach ($member in $group.members) {
                $tmpDesired += ($group.name + "|" + $member).ToLower()
            }
        }
        $tmpDesired
    } else {
        ""
    }
}
# The test value's data type, to help with conversion: bool/string/int
$Type = 'string[]'
# The command(s) to pull the actual value for comparison
# $Object will scope to the folder this test is in (Cluster, Host, etc.)
[ScriptBlock]$Actual = {
   # [string[]]
    $tmpActual = @()
    $groups = Get-DrsClusterGroup -Cluster $object -Type VMHostGroup
    if ($groups.length -ge 1) {
        foreach ($group in $groups) {
            #account for empty groups
            $tmpActual += ($group.name).ToLower()
            foreach ($member in $group.member) {
                $tmpActual += ($group.name + "|"+  $member.name).ToLower()
            }
        }
        $tmpActual
    } else {
        ""
    }
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
