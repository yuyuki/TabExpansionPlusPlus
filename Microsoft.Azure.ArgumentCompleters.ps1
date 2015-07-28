﻿#
# .SYNOPSIS
#
#    Auto-complete the -StorageAccountName parameter value for Azure PowerShell cmdlets.
#
# .NOTES
#    
#    Created by Trevor Sullivan <pcgeek86@gmail.com>
#    http://trevorsullivan.net
#
function StorageAccount_StorageAccountNameCompleter
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    #Write-Verbose -Message ('Called Azure StorageAccountName completer at {0}' -f (Get-Date))

    $CacheKey = 'StorageAccount_StorageAccountNameCache'
    $StorageAccountNameCache = Get-CompletionPrivateData -Key $CacheKey

    ### Return the cached value if it has not expired
    if ($StorageAccountNameCache) {
        return $StorageAccountNameCache
    }

    $StorageAccountList = Get-AzureStorageAccount -WarningAction SilentlyContinue | Where-Object {$PSItem.StorageAccountName -match ${wordToComplete} } | ForEach-Object {
        $CompletionResult = @{
            CompletionText = $PSItem.StorageAccountName
            ToolTip = 'Storage Account "{0}" in "{1}" region.' -f $PSItem.StorageAccountName, $PSItem.Location
            ListItemText = '{0} ({1})' -f $PSItem.StorageAccountName, $PSItem.Location
            CompletionResultType = [System.Management.Automation.CompletionResultType]::ParameterValue
            }
        New-CompletionResult @CompletionResult
    }

    Set-CompletionPrivateData -Key $CacheKey -Value $StorageAccountList
    return $StorageAccountList
}

#
# .SYNOPSIS
#
#    Auto-complete the -Name parameter value for Azure PowerShell storage container cmdlets.
#
# .NOTES
#    
#    Created by Trevor Sullivan <pcgeek86@gmail.com>
#    http://trevorsullivan.net
#
function AzureStorage_StorageContainerNameCompleter
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $CacheKey = 'AzureStorage_ContainerNameCache'
    $ContainerNameCache = Get-CompletionPrivateData -Key $CacheKey

    ### Return the cached value if it has not expired
    if ($ContainerNameCache) {
        return $ContainerNameCache
    }

    $ContainerList = Get-AzureStorageContainer -Context $fakeBoundParameter['Context'] | Where-Object -FilterScript { $PSItem.Name -match ${wordToComplete} } | ForEach-Object {
        $CompletionResult = @{
            CompletionText = $PSItem.Name
            ToolTip = 'Storage Container "{0}" in "{1}" Storage Account.' -f $PSItem.Name, $fakeBoundParameter['Context'].StorageAccountName
            ListItemText = '{0} ({1})' -f $PSItem.Name, $fakeBoundParameter['Context'].StorageAccountName
            CompletionResultType = [System.Management.Automation.CompletionResultType]::ParameterValue
            }
        New-CompletionResult @CompletionResult
    }

    Set-CompletionPrivateData -Key $CacheKey -Value $ContainerList
    return $ContainerList
}

#
# .SYNOPSIS
#
#    Auto-complete the -ServiceName parameter value for Azure PowerShell cmdlets.
#
# .NOTES
#    
#    Created by Trevor Sullivan <pcgeek86@gmail.com>
#    http://trevorsullivan.net
#
function CloudService_ServiceNameCompleter
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    #Write-Verbose -Message ('Called Azure ServiceName completer at {0}' -f (Get-Date))
    $CacheKey = 'CloudService_ServiceNameCache'
    $ServiceNameCache = Get-CompletionPrivateData -Key $CacheKey
    if ($ServiceNameCache) {
        return $ServiceNameCache
    }

    $ItemList = Get-AzureService | Where-Object { $PSItem.ServiceName -match ${wordToComplete} } | ForEach-Object {
        $CompletionResult = @{
            CompletionText = $PSItem.ServiceName
            ToolTip = 'Cloud Service in "{0}" region.' -f $PSItem.ExtendedProperties.ResourceLocation
            ListItemText = '{0} ({1})' -f $PSItem.ServiceName, $PSItem.ExtendedProperties.ResourceLocation
            CompletionResultType = [System.Management.Automation.CompletionResultType]::ParameterValue
            }
        New-CompletionResult @CompletionResult
    }
    Set-CompletionPrivateData -Key $CacheKey -Value $ItemList

    return $ItemList
}

#
# .SYNOPSIS
#
#    Auto-complete the -SubscriptionName parameter value for Azure PowerShell cmdlets.
#
# .NOTES
#    
#    Created by Trevor Sullivan <pcgeek86@gmail.com>
#    http://trevorsullivan.net
#
function Subscription_SubscriptionNameCompleter
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    #Write-Verbose -Message ('Called Azure SubscriptionName completer at {0}' -f (Get-Date))

    ### Attempt to read Azure subscription details from the cache
    $CacheKey = 'AzureSubscription_SubscriptionNameCache'
    $SubscriptionNameCache = Get-CompletionPrivateData -Key $CacheKey

    ### If there is a valid cache for the Azure subscription names, then go ahead and return them immediately
    if ($SubscriptionNameCache) {
        return $SubscriptionNameCache
    }

    ### Create fresh completion results for Azure subscriptions
    $ItemList = Get-AzureSubscription | Where-Object { $PSItem.SubscriptionName -match ${wordToComplete} } | ForEach-Object {
        $CompletionResult = @{
            CompletionText = $PSItem.SubscriptionName
            ToolTip = 'Azure subscription "{0}" with ID {1}.' -f $PSItem.SubscriptionName, $PSItem.SubscriptionId
            ListItemText = '{0} ({1})' -f $PSItem.SubscriptionName, $PSItem.SubscriptionId
            CompletionResultType = [System.Management.Automation.CompletionResultType]::ParameterValue
            }
        New-CompletionResult @CompletionResult
    }
    
    ### Update the cache for Azure subscription names
    Set-CompletionPrivateData -Key $CacheKey -Value $ItemList

    ### Return the fresh completion results
    return $ItemList
}

#
# .SYNOPSIS
#
#    Auto-complete the -Name parameter value for Azure PowerShell virtual machine cmdlets.
#
# .NOTES
#    
#    Created by Trevor Sullivan <pcgeek86@gmail.com>
#    http://trevorsullivan.net
#    http://twitter.com/pcgeek86
#
function AzureVirtualMachine_NameCompleter
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    #Write-Verbose -Message ('Called Azure Virtual Machine Name completer at {0}' -f (Get-Date))

    ### Attempt to read Azure virtual machine details from the cache
    $CacheKey = 'AzureVirtualMachine_NameCache'
    $VirtualMachineNameCache = Get-CompletionPrivateData -Key $CacheKey

    ### If there is a valid cache for the Azure virtual machine names, then go ahead and return them immediately
    if ($VirtualMachineNameCache -and (Get-Date) -gt $VirtualMachineNameCache.ExpirationTime) {
        return $VirtualMachineNameCache
    }

    ### Create fresh completion results for Azure virtual machines
    $ItemList = Get-AzureVM | Where-Object { $PSItem.Name -match ${wordToComplete} } | ForEach-Object {
        $CompletionResult = @{
            CompletionText = '{0} -ServiceName {1}' -f $PSItem.Name, $PSItem.ServiceName
            ToolTip = 'Azure VM {0}/{1} in state {2}.' -f $PSItem.ServiceName, $PSItem.Name, $PSItem.Status
            ListItemText = '{0}/{1}' -f $PSItem.ServiceName, $PSItem.Name
            CompletionResultType = [System.Management.Automation.CompletionResultType]::ParameterValue
            }
        New-CompletionResult @CompletionResult
    }
    
    ### Update the cache for Azure virtual machines
    Set-CompletionPrivateData -Key $CacheKey -Value $ItemList

    ### Return the fresh completion results
    return $ItemList
}


Register-ArgumentCompleter `
    -Command ( Get-CommandWithParameter -Module Azure -ParameterName StorageAccountName ) `
    -Parameter 'StorageAccountName' `
    -Description 'Complete the -StorageAccountName parameter value for Azure cmdlets:  Get-AzureStorageAccount -StorageAccountName <TAB>' `
    -ScriptBlock $function:StorageAccount_StorageAccountNameCompleter


Register-ArgumentCompleter `
    -Command ( Get-CommandWithParameter -Module Azure -ParameterName Name -Name *container* ) `
    -Parameter 'Name' `
    -Description 'Complete the -Name parameter value for Azure cmdlets:  Get-AzureStorageContainer -Context $Context -Name <TAB>' `
    -ScriptBlock $function:AzureStorage_StorageContainerNameCompleter


Register-ArgumentCompleter `
    -Command ( Get-CommandWithParameter -Module Azure -ParameterName ServiceName ) `
    -Parameter 'ServiceName' `
    -Description 'Complete the -ServiceName parameter value for Azure cmdlets:  Get-AzureService -ServiceName <TAB>' `
    -ScriptBlock $function:CloudService_ServiceNameCompleter


Register-ArgumentCompleter `
    -Command ( Get-CommandWithParameter -Module Azure -ParameterName SubscriptionName ) `
    -Parameter 'SubscriptionName' `
    -Description 'Complete the -SubscriptionName parameter value for Azure cmdlets:  Select-AzureSubscription -SubscriptionName <TAB>' `
    -ScriptBlock $function:Subscription_SubscriptionNameCompleter


Register-ArgumentCompleter `
    -Command ( Get-CommandWithParameter -Module Azure -ParameterName Name -Noun AzureVM ) `
    -Parameter 'Name' `
    -Description 'Complete the -Name parameter value for Azure virtual machine cmdlets:  Stop-AzureVM -Name <TAB>' `
    -ScriptBlock $function:AzureVirtualMachine_NameCompleter
