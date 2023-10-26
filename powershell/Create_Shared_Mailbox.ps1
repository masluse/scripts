# Importieren der benötigten Module
Import-Module ActiveDirectory
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName Microsoft.VisualBasic

# Initialisierung der Variablen
$ouList = Get-ADOrganizationalUnit -Filter * | Where-Object { $_.DistinguishedName -notmatch "^OU=.+OU=" } | Select-Object -ExpandProperty Name
# OU Dropdown sortieren
$ouList = $ouList | Sort-Object

# GUI erstellen
$form = New-Object System.Windows.Forms.Form
$form.Text = "Shared Mailbox Creator"
$form.Size = New-Object System.Drawing.Size(400, 500)

# OU Dropdown erstellen
$ouLabel = New-Object System.Windows.Forms.Label
$ouLabel.Text = "OU:"
$ouLabel.Location = New-Object System.Drawing.Point(10, 20)
$form.Controls.Add($ouLabel)

$ouDropdown = New-Object System.Windows.Forms.ComboBox
$ouDropdown.Location = New-Object System.Drawing.Point(120, 20)
$ouDropdown.Size = New-Object System.Drawing.Size(200, 20)
$ouDropdown.Items.AddRange($ouList)
$form.Controls.Add($ouDropdown)

# Anzeigename TextBox
$displayNameLabel = New-Object System.Windows.Forms.Label
$displayNameLabel.Text = "Anzeigename:"
$displayNameLabel.Location = New-Object System.Drawing.Point(10, 50)
$form.Controls.Add($displayNameLabel)

$displayNameTextBox = New-Object System.Windows.Forms.TextBox
$displayNameTextBox.Location = New-Object System.Drawing.Point(120, 50)
$displayNameTextBox.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($displayNameTextBox)

# Alias TextBox (nur anzeigen)
$aliasLabel = New-Object System.Windows.Forms.Label
$aliasLabel.Text = "Alias:"
$aliasLabel.Location = New-Object System.Drawing.Point(10, 80)
$form.Controls.Add($aliasLabel)

$aliasTextBox = New-Object System.Windows.Forms.TextBox
$aliasTextBox.Location = New-Object System.Drawing.Point(120, 80)
$aliasTextBox.Size = New-Object System.Drawing.Size(200, 20)
$aliasTextBox.ReadOnly = $true
$form.Controls.Add($aliasTextBox)

# Domain Label (nur anzeigen)
$domainLabel = New-Object System.Windows.Forms.Label
$domainLabel.Text = "Domain:"
$domainLabel.Location = New-Object System.Drawing.Point(10, 110)
$form.Controls.Add($domainLabel)

$domainTextBox = New-Object System.Windows.Forms.TextBox
$domainTextBox.Location = New-Object System.Drawing.Point(120, 110)
$domainTextBox.Size = New-Object System.Drawing.Size(200, 20)
$domainTextBox.ReadOnly = $true
$form.Controls.Add($domainTextBox)

# Vollzugriff ListBox
$fullAccessLabel = New-Object System.Windows.Forms.Label
$fullAccessLabel.Text = "Vollzugriff:"
$fullAccessLabel.Location = New-Object System.Drawing.Point(10, 140)
$form.Controls.Add($fullAccessLabel)

$fullAccessListBox = New-Object System.Windows.Forms.ListBox
$fullAccessListBox.Location = New-Object System.Drawing.Point(120, 140)
$fullAccessListBox.Size = New-Object System.Drawing.Size(200, 80)
$form.Controls.Add($fullAccessListBox)

# Vollzugriff Hinzufügen Button
$addFullAccessButton = New-Object System.Windows.Forms.Button
$addFullAccessButton.Text = "+"
$addFullAccessButton.Location = New-Object System.Drawing.Point(330, 140)
$addFullAccessButton.Size = New-Object System.Drawing.Size(30, 23)
$form.Controls.Add($addFullAccessButton)

# Vollzugriff Entfernen Button
$removeFullAccessButton = New-Object System.Windows.Forms.Button
$removeFullAccessButton.Text = "-"
$removeFullAccessButton.Location = New-Object System.Drawing.Point(330, 169)
$removeFullAccessButton.Size = New-Object System.Drawing.Size(30, 23)
$form.Controls.Add($removeFullAccessButton)

# Send As ListBox
$sendAsLabel = New-Object System.Windows.Forms.Label
$sendAsLabel.Text = "Send As:"
$sendAsLabel.Location = New-Object System.Drawing.Point(10, 230)
$form.Controls.Add($sendAsLabel)

$sendAsListBox = New-Object System.Windows.Forms.ListBox
$sendAsListBox.Location = New-Object System.Drawing.Point(120, 230)
$sendAsListBox.Size = New-Object System.Drawing.Size(200, 80)
$form.Controls.Add($sendAsListBox)

# Send As Hinzufügen Button
$addSendAsButton = New-Object System.Windows.Forms.Button
$addSendAsButton.Text = "+"
$addSendAsButton.Location = New-Object System.Drawing.Point(330, 230)
$addSendAsButton.Size = New-Object System.Drawing.Size(30, 23)
$form.Controls.Add($addSendAsButton)

# Send As Entfernen Button
$removeSendAsButton = New-Object System.Windows.Forms.Button
$removeSendAsButton.Text = "-"
$removeSendAsButton.Location = New-Object System.Drawing.Point(330, 259)
$removeSendAsButton.Size = New-Object System.Drawing.Size(30, 23)
$form.Controls.Add($removeSendAsButton)

# SMTP Checkbox
$smtpCheckbox = New-Object System.Windows.Forms.CheckBox
$smtpCheckbox.Text = "SMTP Adresse anpassen"
$smtpCheckbox.Location = New-Object System.Drawing.Point(10, 320)
$smtpCheckbox.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($smtpCheckbox)

# SMTP TextBox
$smtpLabel = New-Object System.Windows.Forms.Label
$smtpLabel.Text = "Primary SMTP:"
$smtpLabel.Location = New-Object System.Drawing.Point(10, 350)
$smtpLabel.Enabled = $false
$form.Controls.Add($smtpLabel)

$smtpTextBox = New-Object System.Windows.Forms.TextBox
$smtpTextBox.Location = New-Object System.Drawing.Point(120, 350)
$smtpTextBox.Size = New-Object System.Drawing.Size(200, 20)
$smtpTextBox.Enabled = $false
$form.Controls.Add($smtpTextBox)

# Event-Handler für Validierung
$smtpTextBox.Add_Validating({
    param($sender, $e)

    if ($smtpCheckbox.Checked) {
        if ($sender.Text -notmatch "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$") {
            [System.Windows.Forms.MessageBox]::Show("Bitte geben Sie eine gültige E-Mail-Adresse ein.", "Ungültige Eingabe", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
            $sender.Focus()
            $e.Cancel = $true
        }
    }
})

$smtpCheckbox.Add_CheckedChanged({
    $smtpLabel.Enabled = $smtpCheckbox.Checked
    $smtpTextBox.Enabled = $smtpCheckbox.Checked
    if (-not $smtpCheckbox.Checked) {
        $smtpTextBox.Text = ""
        # Trigger Validierung, um mögliche Fehlerzustände zu bereinigen
        $form.ValidateChildren()
    }
})

# Verantwortlicher
$responsibleLabel = New-Object System.Windows.Forms.Label
$responsibleLabel.Text = "Verantwortlicher:"
$responsibleLabel.Location = New-Object System.Drawing.Point(10, 380)
$form.Controls.Add($responsibleLabel)

$responsibleTextBox = New-Object System.Windows.Forms.TextBox
$responsibleTextBox.Location = New-Object System.Drawing.Point(120, 380)
$responsibleTextBox.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($responsibleTextBox)

# Verantwortlicher Hinzufügen Button
$addResponsibleButton = New-Object System.Windows.Forms.Button
$addResponsibleButton.Text = "+"
$addResponsibleButton.Location = New-Object System.Drawing.Point(330, 380)
$addResponsibleButton.Size = New-Object System.Drawing.Size(30, 23)
$form.Controls.Add($addResponsibleButton)

# Event-Handler für die OU-ComboBox, um den Alias und die Domain anzuzeigen
# Event-Handler
$ouDropdown.Add_SelectedValueChanged({
    $selectedOU = $ouDropdown.SelectedItem
    if ($selectedOU) {
        $aliasPrefix = ($selectedOU -replace "^(sou-|fou-)").ToLower()
        if ($displayNameTextBox.Text) {
            $displayNameCleaned = ($displayNameTextBox.Text -replace ' ', '_').ToLower()
            $aliasTextBox.Text = "$aliasPrefix-res-$displayNameCleaned"
        } else {
            $aliasTextBox.Text = "$aliasPrefix-res-"
        }
        # Extrahieren der Domain aus der ausgewählten OU und Anzeige in der Domain-TextBox
        $ouObject = Get-ADOrganizationalUnit -Filter {Name -eq $selectedOU}
        $domain = ($ouObject.DistinguishedName -split ",DC=")[1..($ouObject.DistinguishedName -split ",DC=").Count] -join "."
        $domainTextBox.Text = $domain
    }
})

# Event-Handler für den Erstellen-Button
$createButton = New-Object System.Windows.Forms.Button
$createButton.Text = "Shared Mailbox erstellen"
$createButton.Location = New-Object System.Drawing.Point(10, 420)
$createButton.Size = New-Object System.Drawing.Size(150, 30)
$form.Controls.Add($createButton)

$createButton.Add_Click({
    try {
        $ou = $ouDropdown.Text
        $displayName = $displayNameTextBox.Text
        $alias = $aliasTextBox.Text
        $fullAccessUsers = $fullAccessListBox.Items
        $sendAsUsers = $sendAsListBox.Items
        $responsible = $responsibleTextBox.Text

        # Überprüfen, ob alle Pflichtfelder ausgefüllt sind
        if (-not $ou -or -not $displayName -or -not $alias) {
            [System.Windows.Forms.MessageBox]::Show("Bitte alle Pflichtfelder ausfüllen.", "Fehler", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            return
        }

        # OU und Domain ermitteln
        $ouObject = Get-ADOrganizationalUnit -Filter {Name -eq $ou}
        $domain = ($ouObject.DistinguishedName -split ",DC=")[1..($ouObject.DistinguishedName -split ",DC=").Count] -join "."
        $domainTextBox.Text = $domain
        
        # Alias und extensionAttribute7 anpassen
        $adjustedAlias = ($ou -replace "^(sou-|fou-)").ToLower() -replace "\s", "_"
        $extensionAttribute7 = $adjustedAlias + ";"
        $adjustedAlias = $adjustedAlias + "-res-" + ($displayName -replace "\s", "_").ToLower()
        
        $ouPath = "$domain/$ou/Resources"
        $sharedMailbox = New-Mailbox -Shared -Name $alias -displayName $displayName -Alias $alias -OrganizationalUnit $ouPath

        Start-Sleep -Seconds 30
        $DC = Get-ADDomainController -Discover -Service "PrimaryDC"

        # Verantwortlichen setzen und AdminDescription im AD setzen
        if ($responsible) {
            $responsibleUser = Get-ADUser -Filter { SamAccountName -eq $responsible }
            if ($responsibleUser) {
                $adminDescription = "EMAIL:" + $responsibleUser.UserPrincipalName
                $user = Get-ADUser -Filter { name -eq $alias } -Server $DC.Name
                Set-ADObject -Server $DC.Name -Identity $user.ObjectGUID -Replace @{ "adminDescription" = $adminDescription }
            } else {
                [System.Windows.Forms.MessageBox]::Show("Der angegebene Benutzer ($responsible) wurde nicht gefunden.", "Fehler", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            }
        }

        # Vollzugriff und Send As Berechtigungen setzen
        # Vollzugriff setzen
        foreach ($user in $fullAccessUsers) {
            Add-MailboxPermission -Identity $sharedMailbox.DistinguishedName -User $user -AccessRights FullAccess
        }

        # Send As setzen
        foreach ($user in $sendAsUsers) {
            Add-ADPermission -Identity $sharedMailbox.DistinguishedName -User $user -AccessRights ExtendedRight -ExtendedRights "Send As"
        }

        # SMTP-Adressen aktualisieren
        $existingEmailAddresses = (Get-Mailbox -Identity $sharedMailbox.DistinguishedName).EmailAddresses
        $newEmailAddresses = @()

        # Bestehende Adressen durchlaufen
        foreach ($address in $existingEmailAddresses) {
            if ($address.PrefixString -eq "SMTP") {
                # Primäre Adresse zu sekundären Adressen hinzufügen, falls eine neue primäre Adresse festgelegt wird
                if ($smtpCheckbox.Checked) {
                    $newEmailAddresses += "smtp:$($address.AddressString)"
                } else {
                    # Primäre Adresse beibehalten, wenn keine neue festgelegt wird
                    $newEmailAddresses += "SMTP:$($address.AddressString)"
                }
            } elseif ($address.AddressString -like "*@fenaco.com") {
                # Bestehende @fenaco.com Adresse als sekundäre Adresse beibehalten
                $newEmailAddresses += "smtp:$($address.AddressString)"
            } else {
                $newEmailAddresses += "$($address.PrefixString):$($address.AddressString)"
            }
        }

        if ($smtpCheckbox.Checked) {
            # Benutzerdefinierte Adresse als primäre Adresse hinzufügen
            $newEmailAddresses += "SMTP:$($smtpTextBox.Text)"
            $primaryAddressSet = $true
        }

        # E-Mail-Adressrichtlinie deaktivieren und SMTP-Adressen setzen
        Set-Mailbox -Identity $sharedMailbox.DistinguishedName -EmailAddressPolicyEnabled $false -EmailAddresses $newEmailAddresses

        # msDS-cloudExtensionAttribute1, extensionAttribute7 und AdminDescription im AD setzen
        $user = Get-ADUser -Filter { name -eq $alias } -Server $DC.Name
        Set-ADObject -Server $DC.Name -Identity $user.ObjectGUID -Replace @{ 
            "msDS-cloudExtensionAttribute1" = $domain
            "extensionAttribute7" = $extensionAttribute7
			"description" = $displayName
			"givenName" = $displayName
			"sn" = "Shared Mailbox"
        }

        [System.Windows.Forms.MessageBox]::Show("Shared Mailbox wurde erfolgreich erstellt.", "Erfolg", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        
        # Schließen der Forms-Anwendung
        [System.Windows.Forms.Application]::Exit()
        
        # Beenden der PowerShell-Sitzung
        Exit
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Es ist ein Fehler aufgetreten: $($_.Exception.Message)", "Fehler", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        
    }
})

# Funktion zum Auswählen des Verantwortlichen
function Select-Responsible {
    $user = Select-User
    if ($user) {
        $responsibleTextBox.Text = $user.SamAccountName
    }
}

# Funktion zum Auswählen eines Benutzers
function Select-User {
    try {
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing

        $search = [Microsoft.VisualBasic.Interaction]::InputBox("Geben Sie den Login-Namen des Benutzers ein:", "Benutzer suchen")
        $users = Get-ADUser -Filter "SamAccountName -like '*$search*'" -Properties DisplayName, SamAccountName

        if ($users.Count -eq 0) {
            [System.Windows.Forms.MessageBox]::Show("Kein Benutzer gefunden.", "Info", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
            return $null
        } elseif ($users.Count -eq 1) {
            return $users.SamAccountName
        } else {
            $form = New-Object System.Windows.Forms.Form
            $listBox = New-Object System.Windows.Forms.ListBox
            $button = New-Object System.Windows.Forms.Button

            $form.Text = 'Benutzer auswählen'
            $form.Size = New-Object System.Drawing.Size(300,300)
            $form.StartPosition = 'CenterScreen'

            $listBox.Location = New-Object System.Drawing.Point(10,10)
            $listBox.Size = New-Object System.Drawing.Size(260,200)
            $users | ForEach-Object { $listBox.Items.Add($_.SamAccountName) }

            $button.Location = New-Object System.Drawing.Point(10,220)
            $button.Size = New-Object System.Drawing.Size(260,30)
            $button.Text = 'OK'
            $button.DialogResult = [System.Windows.Forms.DialogResult]::OK
            $form.AcceptButton = $button

            $form.Controls.Add($listBox)
            $form.Controls.Add($button)

            $result = $form.ShowDialog()
            if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
                $selectedUserSamAccountName = $listBox.SelectedItem
                return Get-ADUser -Identity $selectedUserSamAccountName -Properties DisplayName, SamAccountName
            }
        } else {
            return $null
        }
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Es ist ein Fehler aufgetreten: $($_.Exception.Message)", "Fehler", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return $null
    }
}

$displayNameTextBox.Add_TextChanged({
    $selectedOU = $ouDropdown.SelectedItem
    if ($selectedOU -and $displayNameTextBox.Text) {
        $aliasPrefix = ($selectedOU -replace "^(sou-|fou-)").ToLower()
        $displayNameCleaned = ($displayNameTextBox.Text -replace ' ', '_').ToLower()
        $aliasTextBox.Text = "$aliasPrefix-res-$displayNameCleaned"
    }
})

$addFullAccessButton.Add_Click({
    $user = Select-User
    if ($user) {
        $fullAccessListBox.Items.Add($user.SamAccountName)
    } else {
        [System.Windows.Forms.MessageBox]::Show("No user selected.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})

$removeFullAccessButton.Add_Click({
    if ($fullAccessListBox.SelectedItem) {
        $fullAccessListBox.Items.Remove($fullAccessListBox.SelectedItem)
    }
})

$addSendAsButton.Add_Click({
    $user = Select-User
    if ($user) {
        $sendAsListBox.Items.Add($user.SamAccountName)
    }
})

$removeSendAsButton.Add_Click({
    if ($sendAsListBox.SelectedItem) {
        $sendAsListBox.Items.Remove($sendAsListBox.SelectedItem)
    }
})

# Funktion zum Auswählen des Verantwortlichen
function Select-Responsible {
    $user = Select-User
    if ($user) {
        $responsibleTextBox.Text = $user.SamAccountName
    }
}

$addResponsibleButton.Add_Click({
    Select-Responsible
})

# GUI anzeigen
$form.ShowDialog()
