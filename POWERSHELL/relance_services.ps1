# TITRE relance_services.ps1
# DESCRIPTION : Script pour relancer des services automatiquement
# USAGE : 
# HISTORIQUE :
# T |  Date      |  Auteur              |  Description
#---+------------+----------------------+------------------------------------
# A |  07/02/23  |  GUICHETEAU Thomas   |  Création
# B |  23/02/23  |  GUICHETEAU Thomas   |  Ajout commande création du dossier pour les logs
# ---------------------------------------------------------------------------

# LISTE DES SERVICES
$services = @('MSSQL$SQLEXPRESS',"SQLBrowser")

# CREATION DU DOSSIER POUR ACCUEILLIR LE FICHIER DE LOG
New-Item -Path 'C:\Temp\log' -ItemType Directory

# DEBUT BOUCLE FOR
# POUR CHAQUE SERVICE, CHECK DE SON STATUT. SI KO, RELANCE. SINON, RIEN N'EST FAIT
For($i=0;$i -lt $services.Length;$i++) 
{ 
    # RECUPERATION DU NOM DU SERVICE
    $ServiceName = "$($services[$i])"
    $getService = Get-Service -Name $ServiceName

    # DEBUT BOUCLE WHILE
    # LANCEMENT SI SERVICE KO
    while ($getService.Status -ne 'Running')
    {
        Write-Host "`nService $ServiceName" $getService.Status
        # LOGGING
        Add-Content C:\Temp\log\relance_service.log "$(Get-Date -Format "dd/MM/yyyy HH:mm:ss") : START - Service $ServiceName ..."
        Write-Host "Service $ServiceName starting"
        # DEMARRAGE DU SERVICE
        Start-Service $ServiceName
        Write-Host "`nWait 60s`n"
        # PAUSE 60 SEC
        Start-Sleep -seconds 60
        $getService.Refresh()
        # DEBUT CONDITION
        # VERIFICATION SI SERVICE DE NOUVEAU OK
        # SI NON, REPRISE DE LA BOUCLE WHILE
        if ($getService.Status -eq 'Running')
        {
            # LOGGING
            Add-Content C:\Temp\log\relance_service.log "$(Get-Date -Format "dd/MM/yyyy HH:mm:ss") : OK - Service $ServiceName"
            Write-Host "Service $ServiceName is now Running"
        }
        # FIN CONDITION
    }
    # FIN BOUCLE WHILE 
}
# FIN BOUCLE FOR
# FIN DU SCRIPT