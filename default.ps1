properties {
	#If you want to inc the version number 
	$buildNumber = $env:build
  	if($buildNumber -eq $null)
  	{
    	$buildNumber = "1"
  	}    	
		
	#Should not need to change these 
	
	$chocolateyInstallPath = "http://bit.ly/psChocInstall"
	$chocolateyPath = "c:\chocolatey"
	$chocolateySource ="http://push.pkgs.ttldev" 
	$apiKey = "admin:password"
}

#task default -depends  Clean, WriteNuspecFile, SetVersion, Pack
task default -depends  Clean, InstallChocolatey, WriteNuspecFile, Pack, Push

task WriteNuspecFile {	
	 $file = @(Get-Item *.nuspec)[0]
	 $x = [xml] (Get-Content $file)	    
	 $x.package.metadata.id = $id
	 $x.package.metadata.version = $version
     $x.package.metadata.title = $title 
	 $x.package.metadata.authors = $authors
	 $x.package.metadata.summary = $summary
	 $x.package.metadata.tags = $tags	 
	 $x.Save($file)		 
}

task Clean {
  rmdir -Force *.nupkg;
}

task InstallChocolatey {
  if ((Test-Path -path "$chocolateyPath") -eq $False)
  {
    Install-Chocolatey	
  }
  Set-ChocolateyPath
}

task Pack {	
	& cpack @(Get-Item *.nuspec)[0]
}

task Push {	
	$IsGo = Test-Path -path Env:\GO_PIPELINE_LABEL
	if ($IsGo -eq $true)
	{
		Write-Host "Setting api key"
		& "$chocolateyPath\chocolateyinstall\NuGet.exe" setApiKey "$apiKey"  -Source "$chocolateySource"	
		$file = @(Get-Item *.nupkg)[0]
		cpush $file -Source "$chocolateySource"
	}
	else
	{
		write-host "not pushing, this should be done by CI"
	}	
}

function Install-Chocolatey
{
	Write-Host "Installing chocolatey"
	$wc = (new-object net.webclient);
	$isBehindProxy = Behind-Proxy
 	if ($isBehindProxy -eq $true)
  	{
		$proxy = [System.Net.WebRequest]::GetSystemWebProxy()
		$proxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials		
		$wc.proxy = $proxy
  	}	
 	iex ($wc.DownloadString($chocolateyInstallPath))
}
function Set-ChocolateyPath
{
	$env:Path = $env:Path + ";$chocolateyPath\bin";
}

