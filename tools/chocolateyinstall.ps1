$url   = 'https://github.com/bonki/WinA1314/releases/download/v1.1.10.0/WinA1314-setup-x86.exe'
$url64 = 'https://github.com/bonki/WinA1314/releases/download/v1.1.10.0/WinA1314-setup-x64.exe'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = $url
  url64bit       = $url64
  softwareName   = 'WinA1314*'
  checksum       = 'a35af78833627684c6a9f760c15de2889f04c8a982873b73ab53af7c22430de1'
  checksumType   = 'sha256'
  checksum64     = 'a2bc4ef2a15427665c55a76cdedfa8cf71f7f22629371042ac0c5e1e6b5a9ed2'
  checksumType64 = 'sha256'
  silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes = @(0)
}

[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -gt 1) {
	Write-Warning "$($key.Count) matches found!"
	Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
	Write-Warning "Please alert package maintainer the following keys were matched:"
	$key | % {Write-Warning "- $($_.DisplayName)"}
	return
} elseif ($key.Count -eq 1) {
	$key | % { 
		$packageArgs['file'] = "$($_.UninstallString)"
		Uninstall-ChocolateyPackage @packageArgs
	}
}

Install-ChocolateyPackage @packageArgs

