<#
    .SYNOPSIS
    Add an entry to the trusted host list.

    .DESCRIPTION
    Append the entry to the trusted host list separated by a comma and store it
    in the path WSMan:\localhost\Client\TrustedHosts.

    .INPUTS
    System.String. Trusted host list entry.

    .OUTPUTS
    None.

    .EXAMPLE
    PS C:\> Add-TrsutedHosts -ComputerName 'SERVER', '10.0.0.1', '*.contoso.com'
    Add the three entries to the trusted host list.

    .EXAMPLE
    PS C:\> '10.0.0.1', '10.0.0.2', '10.0.0.3' | Add-TrsutedHosts
    Add the list of IP addresses to the trusted host list.

    .NOTES
    Author     : Claudio Spizzi
    License    : MIT License

    .LINK
    https://github.com/claudiospizzi/SecurityFever
#>

function Add-TrustedHosts
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [System.String[]]
        $ComputerName
    )

    begin
    {
        # The trusted hosts list can only be changed as an administrator.
        if (-not (Test-AdministratorRole))
        {
            throw 'Access denied. Please start this functions as an administrator.'
        }

        # Get the WSMan trusted hosts item, ensure its a string
        $trustedHosts = [String] (Get-Item -Path 'WSMan:\localhost\Client\TrustedHosts').Value
    }

    process
    {
        # Add all new entries
        foreach ($computer in $ComputerName)
        {
            $trustedHosts = '{0},{1}' -f $trustedHosts, $computer
            $trustedHosts = $trustedHosts.Trim(',')
        }
    }

    end
    {
        # Finally, set the item
        Set-Item -Path 'WSMan:\localhost\Client\TrustedHosts' -Value $trustedHosts -Force
    }
}
