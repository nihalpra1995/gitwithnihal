#[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Form")
#[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

Add-Type -AssemblyName system.windows.Forms

$form = New-Object System.Windows.Forms.Form
$form.Text = "Server Checkup"
#$form.Size = New-Object System.Drawing.Size(800,500)
$form.Size = "800,600"


$svrname = New-Object System.Windows.Forms.Label
#$svrname.Location = New-Object System.Drawing.Size(300,50)
#$svrname.Size = New-Object System.Drawing.Size(100,50)
$svrname.Location = "50,50"
$svrname.Size = "70,50"
$svrname.Text = "ServerName"
$svrname.Font = "Yu Gothic UI Light"
$form.Controls.Add($svrname)

$svrtextbox = New-Object System.Windows.Forms.TextBox
$svrtextbox.Location = "150,50"
$svrtextbox.Size = "90,20"
$svrtextbox.Font = "Yu Gothic UI Light"
$form.Controls.Add($svrtextbox)

$resultlabel = New-Object System.Windows.Forms.Label
$resultlabel.Location = "50,100"
$resultlabel.Size = "500,400"
$resultlabel.Font = "Yu Gothic UI Light"
$form.Controls.Add($resultlabel)

$svrcheckbutton = New-Object System.Windows.Forms.Button
$svrcheckbutton.Location = "270,50"
$svrcheckbutton.Size = "90,20"
$svrcheckbutton.Text = "CheckServer"
$svrcheckbutton.Font = "Yu Gothic UI Light"
$form.Controls.Add($svrcheckbutton)

$svrcheckbutton.add_click({

if($svrtextbox.Text -eq "DESKTOP-AON1N7Q")
{
    $devicedrive = Get-WmiObject -ComputerName $svrtextbox.Text -Class win32_volume | ? {$_.DriveLetter -like "*:*"} | Select DriveLetter , FreeSpace, Capacity
    foreach($drive in $devicedrive)
    {
    $driveresult += "DriveLetter: $($drive.DriveLetter) , FreeSpace: $($drive.FreeSpace), TotalSize: $($drive.Capacity) `n"
    }

    $deviceService = Get-Service | ? {$_.StartType -eq "Automatic" -and $_.Status -eq "Stopped"} | Select Name
    foreach ($service in $deviceService.Name)
    {
     $serviceresult += "$service`n"
    }

    $resultlabel.ForeColor = "Green"
    $resultlabel.Text = "Below are the Server Details`n`nDisk Details`n$driveresult`nList of Stopped Automatic Services`n$serviceresult"
}
else
{
$resultlabel.ForeColor = "Red"
$resultlabel.Text = "Server Not found"
}

})

$form.ShowDialog()
