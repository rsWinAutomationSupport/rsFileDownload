function Get-TargetResource
{
	[OutputType([Hashtable])]
	param
	(
		[Parameter()]
		[ValidateSet("Present", "Absent")]
		[string]$Ensure = "Present",
		
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$SourceURL,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$DestinationFolder,
		
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$DestinationFilename
	)
	
	if(!(Test-Path -Path $($DestinationFolder,$DestinationFilename -join "\")))
	{
		Write-Verbose "File is not present and needs to be downloaded."
		$Configuration = @{
					Ensure = $Ensure
					SourceURL = $SourceURL
					DestinationFolder = $DestinationFolder
					DestinationFilename = $DestinationFilename
					}
	}
	else
	{
		Write-Verbose "File is present."
		$Configuration = @{
					Ensure = $Ensure
					SourceURL = $SourceURL
					DestinationFolder = $DestinationFolder
					DestinationFilename = $DestinationFilename
					}
	}
	
		
}




function Set-TargetResource
{
	param
	(
		[Parameter()]
		[ValidateSet("Present", "Absent")]
		[string]$Ensure = "Present",
		
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$SourceURL,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$DestinationFolder,
		
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$DestinationFilename
	)
	try
	{
	$myLogSource = $PSCmdlet.MyInvocation.MyCommand.ModuleName
	New-Eventlog -LogName "DevOps" -Source $myLogSource -ErrorAction SilentlyContinue
	}
	catch {}
	
	if ($Ensure -like 'Present')
	{
		if(!(Test-Path -Path $DestinationFolder)) 
		{
			Write-Verbose "Folder is not present and will be created."
			New-Item $DestinationFolder -type directory
		}

		if(!(Test-Path -Path $($DestinationFolder,$DestinationFilename -join "\"))) 
		{
			Write-Verbose "File is not present and will be downloaded."
			Write-EventLog -LogName DevOps -Source $myLogSource -EntryType Information -EventId 1000 -Message ("File $DestinationFilename not present, downloading")
			$downloadtry = 1
			While ($downloadtry -lt 4)
				{
					try{
						Write-Verbose "Trying download $downloadtry"
						$webclient = New-Object System.Net.WebClient
						$webclient.DownloadFile($SourceURL,$($DestinationFolder,$DestinationFilename -join "\")) -ErrorAction SilentlyContinue
						$downloadtry = 4
					}
					catch{
						if ($downloadtry -lt 3){
						Write-Verbose "Download failed - retrying"
						$downloadtry++
						}
						
						else {
						Write-Verbose "Download failed - retry limit reached"
						Write-EventLog -LogName DevOps -Source $myLogSource -EntryType Information -EventId 1000 -Message ("Retry limit reached attempting to download $SourceURL")
						$downloadtry++	
						}
					}
				}
		}
		else
		{
			Write-Verbose "File is present, no action needed."
		}
	}
	else
	{
		if (!(Test-Path -Path $($DestinationFolder,$DestinationFilename -join "\")))
		{
			Write-Verbose "File is not present, no action needed"
		}
		else
		{
			Write-Verbose "File is present, and will be removed."
			Remove-Item $($DestinationFolder,$DestinationFileName -join "\") -recurse
		}
	}
}




function Test-TargetResource
{
	[OutputType([boolean])]
	param
	(
		[Parameter()]
		[ValidateSet("Present", "Absent")]
		[string]$Ensure = "Present",
		
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$SourceURL,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$DestinationFolder,
		
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$DestinationFilename
	)
	
	$IsValid = $false
	
	$FileLocation = $($DestinationFolder,$DestinationFilename -join "\")
	
	if ($Ensure -like 'Present')
	{
		Write-Verbose "Checking for $DestinationFilename inside $DestinationFolder."
		if(!(Test-Path -Path $($DestinationFolder,$DestinationFilename -join "\")))
		{
			Write-Verbose "File is not present."
		}
		else
		{
			Write-Verbose "File is present."
			$IsValid = $true
		}
	}
	else
	{
		if(!(Test-Path -Path $($DestinationFolder,$DestinationFilename -join "\")))
		{
			Write-Verbose "File is not present."
			$IsValid = $true
		}
		else
		{
			Write-Verbose "File is present."
		}
	}
	return $IsValid
}




													