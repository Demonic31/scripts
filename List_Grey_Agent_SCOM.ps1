#Import the OperationsManager module
Import-Module OperationsManager

#Set date
$Date = Get-Date -Format "dd/MM/yyyy"

#Set CSV location
$CSVLoc = "C:\Temp\grey_state_scom_agents.csv"

#Set Mail adresses
$MailFrom = "noreply@domain.com"
$MailTo = @("team@domain.com", "masterchief@domain.com")
$MailCc = "beermaster@domain.com"

#Set Mail Subject
$MailSubject = "[SCOM][AUTO] Liste Agents Offline - $Date"

#Set SMTP Server
$SMTPSrv = "smtp.domain.com"
   
#Get SCOM agents in grey state
$Agent = Get-SCOMClass -Name Microsoft.Windows.Computer
$Objects = Get-SCOMMonitoringObject -class:$Agent | Where-Object {$_.IsAvailable –eq $false}
  
# Setup array
$SCOMArray = @()
  
# Loop through the servers
ForEach ($Object in $Objects)
{
    Write-Host "Processing: " -NoNewline
    Write-host $object.DisplayName -ForegroundColor Green
     
    # Checking primary managemnt server
    $Mgmt = (Get-SCOMAgent -Name $object.DisplayName).PrimaryManagementServerName
     
    # Create a custom object 
    $SCOMObject = New-Object PSCustomObject
    $SCOMObject | Add-Member -MemberType NoteProperty -Name "Server" -Value $object.DisplayName
    #$SCOMObject | Add-Member -MemberType NoteProperty -Name "AD Site" -Value $object."[Microsoft.Windows.Computer].ActiveDirectorySite"
    #$SCOMObject | Add-Member -MemberType NoteProperty -Name "Primary Management Server" -Value $Mgmt
    #$SCOMObject | Add-Member -MemberType NoteProperty -Name "Last Modified" -Value $object.LastModified
    #$SCOMObject | Add-Member -MemberType NoteProperty -Name "IsAvailable" -Value $object.IsAvailable
    #$SCOMObject | Add-Member -MemberType NoteProperty -Name "Health state" -Value $object.HealthState
    #$SCOMObject | Add-Member -MemberType NoteProperty -Name "In Maintenance Mode" -Value $object.InMaintenanceMode
  
    # Add custom object to our array
    $SCOMArray += $SCOMObject
}
  
# Display results in console
$SCOMArray | Sort-Object -Property Server | Format-Table -AutoSize -Wrap
 
# Open results in pop-up window
#$SCOMArray | Out-GridView -Title "Unhealthy SCOM Agents"
 
# Save results to CSV 
$SCOMArray | Sort-Object -Property Server | Export-Csv -Path "$CSVLoc" -NoTypeInformation -Force

#Set Body content
$BodyList = $SCOMArray | Sort-Object -Property Server | Format-Table -AutoSize -Wrap | Out-String
$Body = "Bonjour, `n`nVoici la liste des Agents SCOM Offline :`n$BodyList`n`nMail hebdomadaire automatique via le script C:\Scripts\grey_state_scom_agents.ps1 sur HOST"

#Send results + CSV by mail
Send-MailMessage -Attachments "$CSVLoc" -Body $Body -From "$MailFrom" -To $MailTo -Cc "$MailCc" -Subject "$MailSubject" -priority High -dno OnSuccess, OnFailure -SmtpServer "$SMTPSrv"