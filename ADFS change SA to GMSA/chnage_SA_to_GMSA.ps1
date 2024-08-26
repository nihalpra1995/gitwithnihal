###################################################################################################################################################
#this is one time process to change tls setting so that nuget can install the module into system

[Net.ServicePointManager]::SecurityProtocol
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord
[Net.ServicePointManager]::SecurityProtocol
Install-PackageProvider -name NuGet -MinimumVersion 2.8.5.201 -force

###################################################################################################################################################


install-module adfstoolbox
import-module adfstoolbox
Import-Module "C:\Program Files\WindowsPowerShell\Modules\ADFSToolbox\2.0.17.0\serviceAccountModule\AdfsServiceAccountModule.psm1"

Add-AdfsServiceAccountRule -ServiceAccount gmsa_ad$ -SecondaryServers clus1
Update-AdfsServiceAccount

Remove-AdfsServiceAccountRule -ServiceAccount lexaradfs -SecondaryServers clus1
Get-AdfsSyncProperties