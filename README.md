## rsFileDownload DSC Module ##

**rsFileDownload** is a PowerShell DSC resource module, which can be used to download any publicly-accessible file and store it in a local folder.

###Changelog###
RELEASE v1.0.1

Added logic to create folder before download attempt.
Added try/catch logic to retry failed downloads 3 times before.

###Usage Examples###
Download Web Platform Installer package to "c:\packages\WebPlatformInstaller_amd64_en-US.msi"

    rsFileDownload WebPI
    {
    	Ensure = "Present"
    	SourceURL = "http://download.microsoft.com/download/7/0/4/704CEB4C-9F42-4962-A2B0-5C84B0682C7A/WebPlatformInstaller_amd64_en-US.msi"
    	DestinationFolder = "c:\packages"
    	DestinationFileName = "WebPlatformInstaller_amd64_en-US.msi"
    	
    }

