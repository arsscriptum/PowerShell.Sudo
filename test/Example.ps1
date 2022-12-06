    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $True, Position=0)]
        [ValidateNotNullOrEmpty()]$Name
    )
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    $IsAdmin = (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)  
    if($IsAdmin){
        Write-Host "Script Running with Elevated Privileges => $IsAdmin. Command argument is $Name" -f DarkGreen
    }else{
        $uname = [Security.Principal.WindowsIdentity]::GetCurrent().Name
        Write-Host "Script Running as user $uname. Limited account" -f DarkRed
    }
    
    Start-Sleep 10