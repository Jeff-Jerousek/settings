Function Get-OSVersion
{
    <#
    .Synopsis
    Get the operating system Version

    .Description
    The Get-OSVersion function gets the version of the operating
    system on a local or remote computer.

    .Parameter Computer
    Enter the name of a local or remote computer. The default
    is the local computer ("localhost").

    .Parameter Detailed
    Returns detailed output from WMI. Use this option if the 
    function returns the "Version Not Listed" error.

    .Notes
    Get-OSVersion uses the Version and ProductType properties of
    the Win32_OperatingSystem WMI class.

    If the operating system is not a version that it recognizes, 
    Get-OSVersion generates a "Version not listed" error. To 
    resolve the error, use the Detailed parameter.

    .Outputs
    With the Detailed parameter, Get-OSVersion returns a 
    System.Management.ManagementObject#root\cimv2\Win32_OperatingSystem
    object. By default, it returns a string with the version name.

    .Example
    Get-OSVersion

    .Example
    get-OSVersion –detailed

    .Example
    get-osVersion –computer Server01 
    #>
    param($computer="localhost",[switch]$Detailed)
    $os = Get-WmiObject Win32_OperatingSystem -computerName $computer -Impersonation Impersonate -Authentication PacketPrivacy
    if ($detailed) { return $os } 
    Switch -regex ($os.Version)
    {
        "5.1.2600" { "Windows XP" }
        "5.1.3790" { "Windows Server 2003" }
        "6.0.6001" {
            if ($os.ProductType -eq 1) {
                "Windows Vista"
            } else {
                "Windows Server 2008"
            }
        } 
        "6.1."    { "Windows 7" }
        DEFAULT { Throw "Version not listed" }
    }
}
