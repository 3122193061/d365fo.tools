﻿
<#
    .SYNOPSIS
        Get file from the Asset library inside the LCS project
        
    .DESCRIPTION
        Get the available files from the Asset Library in LCS project
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
    .PARAMETER FileType
        Type of file you want to upload
        
        Valid options:
        "Model"
        "Process Data Package"
        "Software Deployable Package"
        "GER Configuration"
        "Data Package"
        "PowerBI Report Model"
        "E-Commerce Package"
        "NuGet Package"
        "Retail Self-Service Package"
        "Commerce Cloud Scale Unit Extension"
        
    .PARAMETER BearerToken
        The token you want to use when working against the LCS api
        
    .PARAMETER LcsApiUri
        URI / URL to the LCS API you want to use
        
        Depending on whether your LCS project is located in europe or not, there is 2 valid URI's / URL's
        
        Valid options:
        "https://lcsapi.lcs.dynamics.com"
        "https://lcsapi.eu.lcs.dynamics.com"
        "https://lcsapi.fr.lcs.dynamics.com"
        "https://lcsapi.sa.lcs.dynamics.com"
        "https://lcsapi.uae.lcs.dynamics.com"
        "https://lcsapi.ch.lcs.dynamics.com"
        "https://lcsapi.lcs.dynamics.cn"
        "https://lcsapi.gov.lcs.microsoftdynamics.us"
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Get-LcsAssetFile -ProjectId 123456789 -FileType SoftwareDeployablePackage -BearerToken "JldjfafLJdfjlfsalfd..." -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will get all software deployable packages from the Asset Library inside LCS.
        The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
        The FileType is Software Deployable Packages, with the FileType parameter.
        The request will authenticate with the BearerToken "JldjfafLJdfjlfsalfd...".
        The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).
        
    .NOTES
        Tags: Environment, LCS, Api, AAD, Token, Asset, File, Files
        
        Author: Mötz Jensen (@Splaxi)
#>

function Get-LcsAssetFileV2 {
    [Cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int] $ProjectId,

        [LcsAssetFileType] $FileType,

        [Alias('Token')]
        [string] $BearerToken,
        
        [Parameter(Mandatory = $true)]
        [string] $LcsApiUri,

        [switch] $EnableException
    )

    begin {
        Invoke-TimeSignal -Start
        
        $fileTypeValue = [int]$FileType
        
        $headers = @{
            "Authorization" = "$BearerToken"
        }

        $parms = @{}
        $parms.Method = "GET"
        $parms.Uri = "$LcsApiUri/box/fileasset/GetAssets/$($ProjectId)?fileType=$($fileTypeValue)"
        $parms.Headers = $headers
    }

    process {
        try {
            Write-PSFMessage -Level Verbose -Message "Invoke LCS request."
            Invoke-RestMethod @parms
        }
        catch [System.Net.WebException] {
            Write-PSFMessage -Level Host -Message "Error status code <c='em'>$($_.exception.response.statuscode)</c> in request for listing files from the asset library of LCS. <c='em'>$($_.exception.response.StatusDescription)</c>." -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
            return
        }
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong while working against the LCS API." -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
            return
        }

        Invoke-TimeSignal -End
    }
}
