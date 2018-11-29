# Der er 3 linjer i PowerShell, som skal køres inden dette script virker. Se her! https://syno.mico.dk/dokuwiki/doku.php?id=vejledninger:microsoft:powershell:windows-server-service-status

# Sæt først de forskellige variabler, så det passer til kunden. De første 3 bør ikke ændres, med mindre du vil køre med en speciel SMTP2GO-opsætning.

# Mailserveren hos SMTP2GO. Du er velkommen til at bruge en anden (fx Office 365).
$PSEmailServer = "mail.smtp2go.com"

# Her bliver SMTP-porten angivet. Normalt er der ingen grund til at ændre den.
$SMTPPort = 587

# Her bliver brugernavnet til SMTP2GO angivet. Tilpas efter behov.
$SMTPUsername = "mico@mico.dk"

# Her skal stien til den krypterede kode-fil angives. Tilpas den, så den passer til den fil, du har lavet på kundens server.
$EncryptedPasswordFile = "C:\Scripts\Keys\smtp2go.txt"

# 
$SecureStringPassword = Get-Content -Path $EncryptedPasswordFile | ConvertTo-SecureString
$EmailCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $SMTPUsername,$SecureStringPassword

# Her angiver du mailadressen, som scriptet skal sende til. Brug mico@mico.dk som fra-adresse, hvis du bruger SMTP2GO.
$MailTo = "daniel@mico.dk"
$MailFrom = "mico@mico.dk"

# Tilpas emnefeltet, så det passer til kunde og service:
$MailSubject = "KUNDE: Print Spooler stoppet"

# Det samme gælder selve teksten:
$MailBody = "Print Spooler-service er stoppet gentagne gange. Det skal undersøges!"

# Her bliver scriptet kørt. Ret servicen til, så den passer til kunden.
If ((Get-Service "Print Spooler").Status -eq 'Stopped')
    {Send-MailMessage -From $MailFrom -To $MailTo -Subject $MailSubject -Body $MailBody -Port $SMTPPort -Credential $EmailCredential -Encoding UTF8}