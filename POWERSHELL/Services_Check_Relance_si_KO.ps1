$services = @("service1","service2")

For($i=0;$i -lt $services.Length;$i++) 
{ 
    $ServiceName = "$($services[$i])"
    $getService = Get-Service -Name $ServiceName

    while ($getService.Status -ne 'Running')
    {

        Start-Service $ServiceName
        write-host $getService.status
        write-host 'Service starting'
        Start-Sleep -seconds 60
        $getService.Refresh()
        if ($getService.Status -eq 'Running')
        {
            Write-Host 'Service is now Running'
        }

    }
}
