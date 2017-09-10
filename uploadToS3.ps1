#requires -version 4
<#
.SYNOPSIS
  Copies files from a folder recursively to Amazon S3

.DESCRIPTION
  Copies files from a folder recursively to Amazon S3.  Note: this script uses the 'archive' attribute to determine if a file has been backed up previously.

.INPUTS
  None

.OUTPUTS
  None

.NOTES
  Version:        1.0
  Author:         Jim Gronowski
  Creation Date:  20160520
  Purpose/Change: Initial script 
  
.EXAMPLE
  None
#>

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#Set Error Action to Silently Continue
#$ErrorActionPreference = "SilentlyContinue"


#----------------------------------------------------------[Declarations]----------------------------------------------------------

#Script Version
$sScriptVersion = "1.0"

#Source Folder
$sourceFolder = "Z:\BACKUP\"

#S3 Bucket Name
$s3bucket = "BUCKET_NAME_HERE"

#Folder name (this will be the prefix in the S3 key - like a folder, but not)
$folderName = "FOO"

#Array of files, only including SQL backup files.
$files = Get-ChildItem $sourceFolder -Recurse -Include "*.bak", "*.trn"

#-----------------------------------------------------------[Execution]------------------------------------------------------------


 
foreach ($file in $files)
{
	if( $file.attributes -eq "Archive")
	{
		#Copy the file to S3 
        echo "uploading $($folderName)/$($file.name)"
		Write-S3Object -BucketName $s3bucket -File "$($file.FullName)" -Key "$($folderName)/$($file.Name)" -ServerSideEncryption AES256 -StorageClass "STANDARD_IA"


    	#Flip the archive bit so file will not be uploaded again on next run
		$file.Attributes = $file.Attributes -bxor ([System.IO.FileAttributes]::Archive)
	}
}
