$AzureSubscriptionName = "Subsription"
$AzureServiceAppName = "Service Name"
$ResourceGroupName = 	"Resource Group"
$tier = "Shared" # Free / Shared / Basic / Standard


$connectionName = "automation"
try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         

    "Logging in to Azure..."
    Add-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}

 "changing service plan"

Set-AzureRmAppServicePlan -Name  $AzureServiceAppName -ResourceGroupName $ResourceGroupName -Tier $tier

"complete"

