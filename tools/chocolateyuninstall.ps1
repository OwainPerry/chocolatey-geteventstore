$name = "geteventstore"
try {

  & c:\apps\geteventstore\EventStoreService.exe uninstall

  rmdir -force -recurse c:\apps\geteventstore


  IF ($LASTEXITCODE -ne 0)
  {
    Write-ChocolateyFailure $name "Failed to uninstall with exit code: $LASTEXITCODE"
    throw  
  }
  Write-ChocolateySuccess $name
} catch {
  Write-ChocolateyFailure $name $($_.Exception.Message)
  throw
}  