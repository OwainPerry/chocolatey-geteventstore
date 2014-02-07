try {
  # just a simple xcopy install for now. 


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
 
  #Copy the service wrapper to the same folder 
  copy $(Split-Path -parent $MyInvocation.MyCommand.Definition) + "\..\data\*.*" "c:\apps\geteventstore"

  & c:\apps\geteventstore\EventStoreService.exe install

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