$OutputEncoding = [Console]::OutputEncoding
# Forbind til Exchange Online Powershell
$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session

Clear-Host

# Angiver den bruger, som skal deaktiveres og arkiveres
$Postkasse = Read-Host -Prompt 'Skriv den primære mailadresse på den bruger, der skal deaktiveres og arkiveres'

# Finder brugernavnet ud fra mailadressen:
$Bruger = Get-Aduser -Filter {emailaddress -Like $Postkasse} -Properties DisplayName

# Konverter til Delt Postkasse
Get-Mailbox $Postkasse | Set-Mailbox -Type Shared -Confirm:$false

# Deaktiver bruger
Get-Aduser -Filter {emailaddress -Like $Postkasse} | Disable-ADAccount

# Omdøb bruger til Arkiv - NAVN:
$Dato= (Get-Date).ToShortDateString()
$NytNavn = "Arkiv - "+ $Bruger.Name+" - deaktiveret "+$Dato
Get-ADUser $Bruger | Set-ADUser -DisplayName $NytNavn -Description $NytNavn

# Skjul fra adresseliste
Get-Aduser -Filter {emailaddress -Like $Postkasse} | Set-ADUser -Replace @{msExchHideFromAddressLists=$true}

# Fjerne mailaliasser? Eller køre med Autosvar?

# Flyt til Deaktiverede brugere-OU. HUSK at rette OU, så det passer til kunden!
Get-Aduser -Filter {emailaddress -Like $Postkasse} | Move-ADObject -TargetPath "OU=Deaktiverede brugere,OU=Brugere,OU=Fuglenes Hus,DC=dofdom09,DC=local"

# Synkroniser med Azure AD:
Start-ADSyncSyncCycle -PolicyType Delta

# Fjern forbindelsen til Exchange Online PowerShell:
Remove-PSSession $Session   

# Kilder:
# https://itknowledgeexchange.techtarget.com/powershell/renaming-a-user/
# https://gheywood.wordpress.com/2012/10/16/rename-ad-users-with-powershell/