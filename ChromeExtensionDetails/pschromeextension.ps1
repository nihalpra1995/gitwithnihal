<#
.SYNOPSIS
 Retrieve information about Google Chrome extension

 .DESCRIPTION
 Extract Google Chrome extension from all the user profile and store the output in CSV file.
 1. Find all the userprofile created in device.
 2. Check if extension default folder exists in userprofile.
 3. Find all the extensions Id folder under Extension default folder of userprofile.
 4. Check for the extension details within manifest.json file under version folder of extension id folder.
 5. If manifest.json file contain extension name as "__MSG",
    a. Look for the folder name either "En" or "En_US" (assuming the user follows english as local language) under _locales folder under version folder of extension id folder.
    b. check for messages.json file within "En" or "En_US"
    c. Extract the details of extension name.
 6. Once it extract all the details , save it in csv file and store the output in C:

 .EXAMPLE
  .\get-chromeextension.ps1

 .NOTES
    Author:     Nihal Prasad
    Created:    5/27/25
    Version:    1.1.0
    Requirements:
     - Run as Administrator is mandatory.

 #>

if((Test-Path -Path "C:\$env:COMPUTERNAME.csv") -eq $false)
{

$result = @()

$username = (Get-ChildItem "C:\Users\").Name

$extensiondefaultfolder = "\AppData\Local\Google\Chrome\User Data\Default\Extensions"

$filename = "manifest.json"

$filenametolookup = "messages.json"

$foldertolookup = @("en","en_US")


foreach($user in $username)
{    
    $extfolder = "C:\Users\$user\$extensiondefaultfolder"
    try{

        if(Test-Path -Path $extfolder)
            {
          
            $extfoldername = (Get-ChildItem -Path $extfolder).Name
                        
            foreach($foldername in $extfoldername)
            {  
                    
                $extverfolder = (Get-ChildItem -Path "$extfolder\$foldername").Name
                
                foreach($verfolder in $extverfolder)
                {
                         
                    $manifestdetails = Get-Content -Path "$extfolder\$foldername\$verfolder\$filename" -ErrorAction SilentlyContinue | Out-String | ConvertFrom-Json
                
                    $extensionversion = $manifestdetails.Version
                    $extensionname = $manifestdetails.Name

                    if($extensionname -like "*__MSG*")
                    {
                              if(Test-Path -Path "$extfolder\$foldername\$verfolder\_locales\$($foldertolookup[0])" )
                              {
                              $extappname = Get-Content -Path "$extfolder\$foldername\$verfolder\_locales\$($foldertolookup[0])\$filenametolookup" | ConvertFrom-Json
                              $trimappname = $extensionname.Replace("__MSG_","").Replace("__","")
                              $extensionname = $extappname.$trimappname | select -ExpandProperty message
                              }
                              else
                              {
                              $extappname = Get-Content -Path "$extfolder\$foldername\$verfolder\_locales\$($foldertolookup[1])\$filenametolookup" | ConvertFrom-Json
                              $trimappname = $extensionname.Replace("__MSG_","").Replace("__","")
                              $extensionname = $extappname.$trimappname | select -ExpandProperty message
                              }
                         
                    }

                    $result +=[pscustomobject]@{
                    ComputerName = $env:COMPUTERNAME
                    UserName = $user
                    ExtName = $extensionname
                    ExtID = $foldername
                    ExtVersion = $extensionversion
                    }
                }     

            }
           }
           
    }
    catch{}
    
}
$result  | Export-Csv -Path "C:\$env:COMPUTERNAME.csv" -NoTypeInformation
}
else
{
Write-Host "$env:COMPUTERNAME.csv file already preset in C: `nPlease remove or rename the file and run the script again" -ForegroundColor Red
}
