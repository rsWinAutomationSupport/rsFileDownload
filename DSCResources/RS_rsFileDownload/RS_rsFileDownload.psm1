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
	if ($Ensure -like 'Present')
	{
		if(!(Test-Path -Path $($DestinationFolder,$DestinationFilename -join "\"))) 
		{
			Write-Verbose "File is not present and will be downloaded."
			$downloadtry = 1
			While ($downloadtry -lt 3)
				{
					try{
						$downloadtry = 3
						$webclient = New-Object System.Net.WebClient
						$webclient.DownloadFile($SourceURL,$($DestinationFolder,$DestinationFilename -join "\"))
					}
					catch{
						Write-Verbose "retrying"
						$downloadtry++
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




													