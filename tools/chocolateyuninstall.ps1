try {

  taskkill /s srvmain /f /im EventStore.SingleNode.exe 

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