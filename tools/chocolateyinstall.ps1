try {

  if ($env:ChocolateyInstall -eq $null)
  {
    $env:ChocolateyInstall = "c:\chocolatey"
  }

  $install_path = "c:\apps\geteventstore"
  if ((Test-path -path $install_path -pathtype container) -eq $true)
  {   
    rmdir -force -Recurse "c:\apps\geteventstore" 
  }

  Install-ChocolateyZipPackage 'geteventstore' 'http://download.geteventstore.com/binaries/eventstore-net-2.0.1.zip' "c:\apps\geteventstore"
  $from = $(Split-Path -parent $MyInvocation.MyCommand.Definition) + "\..\data\*.*"

  #Copy the service wrapper to the same folder 
  copy -Path $from -Destination "c:\apps\geteventstore\"

  & c:\apps\geteventstore\EventStoreService.exe install

 echo $null >EventStoreService.exe.ignore

 IF ($LASTEXITCODE -ne 0)
  {
    Write-ChocolateyFailure $name "Failed to setup service with exit code: $LASTEXITCODE"
    throw  
  }

  Write-ChocolateySuccess $name
} catch {
  Write-ChocolateyFailure $name $($_.Exception.Message)
  throw
}  