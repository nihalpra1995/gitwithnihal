#-----------------------------------------------------------------------
#This is one time setup to kds root in AD DC

#add kds root key for msa or gmsa account
Add-KdsRootKey –EffectiveTime ((get-date).addhours(-10))

#confirm if key has been added
Get-KdsRootKey
Test-KdsRootKey -KeyId (Get-KdsRootKey).KeyId

#-------------------------------------------------------------------------

#create msa account
New-ADServiceAccount -Name msa_ad –RestrictToSingleComputer

#add msa account to server
$Identity = Get-ADComputer -identity clus1
Add-ADComputerServiceAccount -Identity $identity -ServiceAccount msa_ad

#install msa into server
Add-WindowsFeature RSAT-AD-PowerShell -includeallsubfeature
Install-ADServiceAccount -Identity msa_ad

#test
Test-ADServiceAccount msa_ad

#-------------------------------------------------------------------------


#create group for gmsa account
New-ADGroup -Name "gmsa_group" -GroupScope Global -GroupCategory Security -Path "OU=LexarGroup,DC=Lexar,DC=local"

#add server to AD group of gmsa
Add-ADGroupMember "gmsa_group" -Members clus1$,clus2$

#to confirm whether member is added
Get-ADGroupMember -Identity "gmsa_group"

#create GMSA account and bind it to group
New-ADServiceAccount -Name gmsa_ad -DNSHostName gmsa_ad.lexar.local -PrincipalsAllowedToRetrieveManagedPassword "gmsa_group" -Verbose

#restart the computer which has been added to gmsa group or refresh ad group memmbership on server without restart
restart-computer -ComputerName clus1,clus2 -force

# "klist.exe -lh 0 -li 0x3e7 purge" run this on server which has been added to gmsa group if you want to restart the server

#add rsat feature to host server
Add-WindowsFeature RSAT-AD-PowerShell -includeallsubfeature

#test GMSA Account
Test-ADServiceAccount gmsa_ad