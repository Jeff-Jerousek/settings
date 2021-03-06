function Remove-Feed {
    <#
    .Synopsis
    Deletes an RSS feed.

    .Description
    The Remove-Feed function deletes an RSS feed and its articles and unsubscribes from the feed.
    By default, Remove-Feed prompts you for confirmation before it deletes each RSS feed.

    .Parameter Feed
    Specifies a feed object, such as one that Get-Feed returns.
    Enter a variable that contains the object or a command that gets the object.
    You can also pipe feed objects from Get-Feed to Remove-Feed.

    .Parameter Name
    Enter the name of an RSS feed. Wildcards are permitted.
    This is the value of the Name property of the object that Get-Feed returns.

    .Parameter Force
    Suppresses the prompt. By default, Remove-Feed prompts you before deleting the RSS feed.

    .Example
    Get-Feed "Windows PowerShell Blog" | Remove-Feed

    .Example
    Remove-Feed –name "Windows PowerShell Blog" -force

    .Example
    Remove-Feed –name *2008* -force

    .Example
    # Deletes all RSS feeds.
    Get-Feed | Remove-Feed

    .Notes
    The Remove-Feed function is exported by the PSRSS module. For more information, see about_PSRSS_Module.

    The Remove-Feed function uses the Delete method of Microsoft.FeedsManager objects.

    .Link
    about_PSRSS_Module

    .Link
    Get-Feed

    .Link
    "Windows RSS Platform" in MSDN
    http://msdn.microsoft.com/en-us/library/ms684701(VS.85).aspx

    .Link
    "Microsoft.FeedsManager Object" in MSDN
    http://msdn.microsoft.com/en-us/library/ms684749(VS.85).aspx

    #>

    [CmdletBinding(DefaultParameterSetName="FeedObject")]
    param(
        # The output from Get-Feed or Get-Article
        [Parameter(ValueFromPipeline=$true)]
        [ValidateScript({
            $_.PSObject.TypeNames[0] -eq "System.__ComObject#{33f2ea09-1398-4ab9-b6a4-f94b49d0a42e}"
        })]
        [__ComObject]
        $Feed,
        
        # The name of the feed to remove
        [Parameter(
            ParameterSetName='Feed',
            ValueFromPipeline=$true,
            Mandatory=$true, 
            Position=0)]
        [String[]]
        $Name,
        
        # If Set, will not prompt the user to continue
        [Switch]$Force
    ) 
    
    
    Process {
        if (-not $feed) { 
            $feed = Get-Feed $Name
            if (-not $feed) {
                throw "Feed $feed does not exist"
            }
        }
        $typeName = $feed.PSObject.TypeNames[0]
        switch ($TypeName) {
            "System.__ComObject#{33f2ea09-1398-4ab9-b6a4-f94b49d0a42e}" { 
                # Feed
                if (-not $Force) {
                    if (-not $psCmdlet.ShouldContinue($Feed.Name, 
                        "Remove Feed?")) {
                        return
                    }
                }
                $Feed.Delete()
            }
        }        
    }
}