<#
#ฬท๐   ๐๐ก๐ข ๐ข๐๐ก๐๐๐ฃ๐ค๐
#ฬท๐   ๐ตโโโโโ๐ดโโโโโ๐ผโโโโโ๐ชโโโโโ๐ทโโโโโ๐ธโโโโโ๐ญโโโโโ๐ชโโโโโ๐ฑโโโโโ๐ฑโโโโโ ๐ธโโโโโ๐จโโโโโ๐ทโโโโโ๐ฎโโโโโ๐ตโโโโโ๐นโโโโโ ๐งโโโโโ๐พโโโโโ ๐ฌโโโโโ๐บโโโโโ๐ฎโโโโโ๐ฑโโโโโ๐ฑโโโโโ๐ฆโโโโโ๐บโโโโโ๐ฒโโโโโ๐ชโโโโโ๐ตโโโโโ๐ฑโโโโโ๐ฆโโโโโ๐ณโโโโโ๐นโโโโโ๐ชโโโโโ.๐ถโโโโโ๐จโโโโโ@๐ฌโโโโโ๐ฒโโโโโ๐ฆโโโโโ๐ฎโโโโโ๐ฑโโโโโ.๐จโโโโโ๐ดโโโโโ๐ฒโโโโโ
#>




<#
.SYNOPSIS
    Invoke a command with Elevated Privilege

.DESCRIPTION
    Invoke a command with Elevated Privilege Note that this uses PowerShell Core (pwsh.exe)
    to use legacy powershell, change pwsh.exe to powershell.exe
    BLOCKING CALL - Returns after execution
.NOTES
    BLOCKING CALL - Returns after execution
#>

function Invoke-ElevatedPrivilege{
    try {

        $NumArgs = $args.Length
        if($NumArgs -eq 0){ 
            Write-Warning "No Command Specified..."
            return 
        }

        $SudoedCommand = ''
        ForEach( $word in $args)
        {
            $SudoedCommand += $word
            $SudoedCommand += ' '
        }
    $SudoedCommand += ' '
    $SudoedCommand += ';`nStart-Sleep 5;'

    $bytes = [System.Text.Encoding]::Unicode.GetBytes($SudoedCommand)
    $encodedCommand = [Convert]::ToBase64String($bytes)

    $ArgumentList = " -noprofile -encodedCommand $encodedCommand"
    $startProcessParams = @{
        FilePath               = (Get-Command $((Get-Process -Id $Pid).ProcessName)).Source
        Wait                   = $true
        PassThru               = $true
    }

    [System.Diagnostics.Process]$cmd = Start-Process @startProcessParams -ArgumentList $ArgumentList -Verb RunAs
    $handle = $cmd.Handle # cache proc.Handle
    $cmd.WaitForExit();
    
    $cmdExitCode = $cmd.ExitCode
    $cmdId = $cmd.Id 
    $cmdHasExited=$cmd.HasExited 
    $cmdTotalProcessorTime=$cmd.TotalProcessorTime     


    }catch{
        [System.Management.Automation.ErrorRecord]$Record = $_
        $formatstring = "{0}`n{1}"
        $fields = $Record.FullyQualifiedErrorId,$Record.Exception.ToString()
        $ExceptMsg=($formatstring -f $fields)
        $Stack=$Record.ScriptStackTrace
        Write-Host "[Invoke-ElevatedPrivilege] -> " -NoNewLine -ForegroundColor Red; 
        Write-Host "$ExceptMsg" -ForegroundColor Yellow
    }
}


 New-Alias 'Invoke-ElevatedPrivilege' -Name 'MySudo' -Description 'Launch a command with elevated privileges' -Force -Scope Global -ErrorAction Ignore