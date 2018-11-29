$OutputEncoding = [Console]::OutputEncoding

# Forbind til Exchange Online Powershell
$Admin = "mico@mico.dk"
$Kode = Get-Content "C:\Scripts\Koder\mico.txt" | ConvertTo-SecureString
$Logon = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Admin, $Kode
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $Logon -Authentication Basic -AllowRedirection
Import-PSSession $Session

Clear-Host

# Lav liste over alle aktive brugere i Deaktiverede brugere.
# Brug efterfølgende brugernavnene én ad gangen til at køre resten af scriptet.

# Kør scriptet, når brugern(e) er blevet rykket (EventID 5139?) (Audit?)

# Finder alle brugere i Deaktiverede brugere OU
$Brugere = Get-ADUser -Filter * -SearchBase "OU=Deaktiverede brugere,OU=MICO,DC=micodom,DC=local" -Properties DisplayName

// SKAL HENTE OPLYSNINGER FRA DEAKTIVERET-OU
# Angiver de brugere, som skal arkiveres

# Konverter til Delt Postkasse


# Deaktiver bruger
Get-Aduser -Filter {emailaddress -Like $Postkasse} | Disable-ADAccount

# Omdøb bruger til Arkiv - NAVN:
$Dato= (Get-Date).ToShortDateString()
$NytNavn = "Arkiv - "+ $Bruger.Name+" - deaktiveret "+$Dato
Get-ADUser $Bruger | Set-ADUser -DisplayName $NytNavn -Description $NytNavn

# Skjul fra adresseliste
Get-Aduser -Filter {emailaddress -Like $Postkasse} | Set-ADUser -Replace @{msExchHideFromAddressLists=$true}

# Fjerner brugeren fra eventuelle mail-lister

# Fjerne mailaliasser? Eller køre med Autosvar?

// OVERFLØDIGT
# Flyt til Deaktiverede brugere-OU. HUSK at rette OU, så det passer til kunden!
Get-Aduser -Filter {emailaddress -Like $Postkasse} | Move-ADObject -TargetPath "OU=Deaktiverede brugere,OU=Brugere,OU=Fuglenes Hus,DC=dofdom09,DC=local"

# Synkroniser med Azure AD:
Start-ADSyncSyncCycle -PolicyType Delta

# Fjern forbindelsen til Exchange Online PowerShell:
Remove-PSSession $Session   

# Kilder:
# https://itknowledgeexchange.techtarget.com/powershell/renaming-a-user/
# https://gheywood.wordpress.com/2012/10/16/rename-ad-users-with-powershell/