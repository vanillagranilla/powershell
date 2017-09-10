$UserName = Read-Host 'Username?'
$Password = Read-Host 'Password?' -AsSecureString; #In case someone is looking over your shoulder :P 
$Domain = Read-Host 'Domain?'
$PasswordAsString = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))

Add-Type -AssemblyName System.DirectoryServices.AccountManagement
$CT = [System.DirectoryServices.AccountManagement.ContextType]::Domain
$PC = New-Object System.DirectoryServices.AccountManagement.PrincipalContext($CT, $Domain)
$IsValid = $PC.ValidateCredentials($UserName, $PasswordAsString).ToString()
"Valid? $IsValid"
