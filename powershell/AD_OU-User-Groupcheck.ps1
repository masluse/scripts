# Importieren der notwendigen Module und Assemblies
Import-Module ActiveDirectory
Add-Type -AssemblyName System.Windows.Forms

# Hauptformular-Eigenschaften
$form = New-Object System.Windows.Forms.Form
$form.Text = "AD User Group Checker"
$form.Size = New-Object System.Drawing.Size(700, 500)

# OU ListBox
$ouLabel = New-Object System.Windows.Forms.Label
$ouLabel.Text = "OU (Name):"
$ouLabel.Location = New-Object System.Drawing.Point(10, 50)
$form.Controls.Add($ouLabel)

$ouListBox = New-Object System.Windows.Forms.ListBox
$ouListBox.Location = New-Object System.Drawing.Point(150, 50)
$ouListBox.Size = New-Object System.Drawing.Size(220, 120)
$ouListBox.SelectionMode = [System.Windows.Forms.SelectionMode]::MultiExtended
$form.Controls.Add($ouListBox)


# Gruppen Textfeld
$groupLabel = New-Object System.Windows.Forms.Label
$groupLabel.Text = "Group Name:"
$groupLabel.Location = New-Object System.Drawing.Point(10, 180)  # Runter verschoben
$form.Controls.Add($groupLabel)

$groupTextBox = New-Object System.Windows.Forms.TextBox
$groupTextBox.Location = New-Object System.Drawing.Point(150, 180)  # Runter verschoben
$groupTextBox.Size = New-Object System.Drawing.Size(220, 20)  # Vergrößern falls nötig
$form.Controls.Add($groupTextBox)

# Domänen ComboBox
$domainLabel = New-Object System.Windows.Forms.Label
$domainLabel.Text = "Domain:"
$domainLabel.Location = New-Object System.Drawing.Point(10, 10)
$form.Controls.Add($domainLabel)

$domainComboBox = New-Object System.Windows.Forms.ComboBox
$domainComboBox.Location = New-Object System.Drawing.Point(150, 10)
$domainComboBox.Size = New-Object System.Drawing.Size(220, 30)
$form.Controls.Add($domainComboBox)

# DataGridView zur Anzeige der Ergebnisse
$dataGridView = New-Object System.Windows.Forms.DataGridView
$dataGridView.Location = New-Object System.Drawing.Point(10, 210)
$dataGridView.Size = New-Object System.Drawing.Size(660, 200)
$dataGridView.ColumnCount = 4
$dataGridView.ColumnHeadersVisible = $true
$dataGridView.RowHeadersVisible = $false
$dataGridView.Columns[0].Name = 'UserName'
$dataGridView.Columns[1].Name = 'Membership'
$dataGridView.Columns[2].Name = 'GroupName'
$dataGridView.Columns[3].Name = 'IsMember'
$form.Controls.Add($dataGridView)

# Button zum Überprüfen der Benutzer
$checkButton = New-Object System.Windows.Forms.Button
$checkButton.Text = "Check Users"
$checkButton.Location = New-Object System.Drawing.Point(10, 420)  
$checkButton.Size = New-Object System.Drawing.Size(100, 30)
$form.Controls.Add($checkButton)

# Button zum Exportieren der Daten als CSV
$exportButton = New-Object System.Windows.Forms.Button
$exportButton.Text = "Export to CSV"
$exportButton.Location = New-Object System.Drawing.Point(150, 420)
$exportButton.Size = New-Object System.Drawing.Size(100, 30)
$form.Controls.Add($exportButton)

# Button Click-Event zum Überprüfen der Benutzer
$checkButton.Add_Click({
    # Achten Sie darauf, dass Sie hier die SelectedItems-Eigenschaft verwenden
    $ous = $ouListBox.SelectedItems
    $groupNames = $groupTextBox.Text -split ','

    $dataGridView.Rows.Clear()

    # Hier gehen wir davon aus, dass jede OU einzeln behandelt werden kann.
    foreach ($ouName in $ous) {
        try {
            $ouName = $ouName -as [string] 
            if($null -ne $ouName) {
                $ouName = $ouName.Trim()
            }
            else {
                throw "OU name is null or not a string."
            }
            
            $ou = (Get-ADOrganizationalUnit -Filter {Name -eq $ouName} -Server $domainComboBox.SelectedItem).DistinguishedName
        }
        catch {
            [System.Windows.Forms.MessageBox]::Show("Error processing OU ($ouName): $_", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            continue
        }

        foreach ($groupName in $groupNames) {
            try {
                $groupName = $groupName -as [string]
                if($null -eq $groupName) {
                    throw "Group name is null."
                }
                $groupName = $groupName.Trim()

                $groupDN = (Get-AdGroup $groupName).DistinguishedName
            }
            catch {
                [System.Windows.Forms.MessageBox]::Show("Error processing group ($groupName): $_", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
                continue
            }
            
            try {
                $users = Get-ADUser -Filter * -SearchBase $ou -Properties MemberOf
                foreach ($user in $users) {
                    $isMember = $user.MemberOf -contains $groupDN
                    $dataGridView.Rows.Add($user.SamAccountName, $ouName, $groupName, $isMember)
                }
            }
            catch {
                [System.Windows.Forms.MessageBox]::Show("Error processing users in OU ($ouName): $_", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            }
        }
    }
})

# Button Click-Event zum Exportieren der Daten als CSV
$exportButton.Add_Click({
    $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveFileDialog.Filter = "CSV files (*.csv)|*.csv"
    $saveFileDialog.FileName = "$($ouTextBox.Text)_$($groupTextBox.Text)_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"

    if ($saveFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $exportPath = $saveFileDialog.FileName

        $dataGridView.Rows |
            Select-Object @{Name='UserName';Expression={$_.Cells[0].Value}},
                          @{Name='Membership';Expression={$_.Cells[1].Value}},
                          @{Name='GroupName';Expression={$_.Cells[2].Value}},
                          @{Name='IsMember';Expression={$_.Cells[3].Value}} |
            Export-Csv -Path $exportPath -NoTypeInformation
    }
})

# Domänen Auflistung
try {
    $domains = (Get-ADForest).Domains
    $domainComboBox.Items.AddRange($domains)
}
catch {
    [System.Windows.Forms.MessageBox]::Show("Error getting domains: $_", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    return
}

# Event für Änderungen in der Domänen-ComboBox
$domainComboBox.Add_SelectedIndexChanged({
    $ouListBox.Items.Clear()
    
    try {
        $selectedDomain = $domainComboBox.SelectedItem.ToString()
        $selectedDomainDN = (Get-ADDomain -Identity $selectedDomain).DistinguishedName
        
        # Abrufen aller OUs, die direkt unter der Domänenwurzel liegen
        $topLevelOUs = Get-ADOrganizationalUnit -Filter * -SearchBase $selectedDomainDN -SearchScope OneLevel

        # Hinzufügen der Namen der obersten OUs zur ListBox
        foreach ($ou in $topLevelOUs) {
            $ouListBox.Items.Add($ou.Name)
        }
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show("Error getting OUs: $_", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})




# Button Click-Event zum Exportieren der Daten als CSV
$exportButton.Add_Click({
    $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveFileDialog.Filter = "CSV files (*.csv)|*.csv"
    $saveFileDialog.FileName = "$($ouTextBox.Text)_$($groupTextBox.Text)_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"

    if ($saveFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $exportPath = $saveFileDialog.FileName

        $dataGridView.Rows |
            Select-Object @{Name='UserName';Expression={$_.Cells[0].Value}},
                          @{Name='Membership';Expression={$_.Cells[1].Value}},
                          @{Name='GroupName';Expression={$_.Cells[2].Value}},
                          @{Name='IsMember';Expression={$_.Cells[3].Value}} |
            Export-Csv -Path $exportPath -NoTypeInformation
    }
})

# Anzeigen des Formulars
$form.ShowDialog()
