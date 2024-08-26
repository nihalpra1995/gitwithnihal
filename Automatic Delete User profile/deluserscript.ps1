Function dellogs($entry)
{
Add-Content -Path "C:\deluser\dellogs.txt" -Value "$(Get-Date) : $entry"
}

Function DelUser()
{
$srchevnt = @{"LogName"="Security";Id=4647}
$evnt = Get-WinEvent -FilterHashtable $srchevnt -MaxEvents 1
$userdel = $evnt.properties[1].value
Get-WmiObject -Class Win32_userprofile | Where-Object {$_.LocalPath.split("\")[-1] -eq $userdel}|Remove-WmiObject
dellogs("$userdel has been deleted")
}

DelUser