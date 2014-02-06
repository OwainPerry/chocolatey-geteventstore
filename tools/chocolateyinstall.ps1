$install_path = "c:\apps\demo.rest.service"
$name = "demo.rest.service"
try {
 
  Install-ChocolateyZipPackage 'geteventstore' 'http://download.geteventstore.com/binaries/eventstore-net-2.0.1.zip' "c:\apps\geteventstore"
 
  Write-ChocolateySuccess $name
} catch {
  Write-ChocolateyFailure $name $($_.Exception.Message)
  throw
}  