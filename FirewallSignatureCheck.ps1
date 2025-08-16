# Ordner vorbereiten
$OutDir = "C:\temp"
$OutFile = Join-Path $OutDir "firewallrules_sign.txt"
$faPath = "HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules"

if (-not (Test-Path $OutDir)) {
    New-Item -Path $OutDir -ItemType Directory | Out-Null
}

# Firewall-Regeln laden
$faRules = Get-ItemProperty -Path $faPath

# Dateipfade aus den Regeln extrahieren
$filePaths = $faRules.PSObject.Properties |
    Where-Object { $_.Value -match 'app=([^\"]+)' } |
    ForEach-Object {
        $fp = $Matches[1] `
            -replace "ProgramFiles \(x86\)", "$($env:SystemDrive)\Program Files (x86)" `
            -replace "SystemRoot", "$($env:SystemRoot)" `
            -replace "PROGRAMFILES", "$($env:SystemDrive)\Program Files" `
            -replace "USERNAME", "$($env:USERNAME)"
        $fp
    }

# Doppelte entfernen
$uniquePaths = $filePaths | Select-Object -Unique

# Signaturen prüfen
$results = foreach ($path in $uniquePaths) {
    try {
        $sig = Get-AuthenticodeSignature -FilePath $path -ErrorAction Stop
        if ($sig.Status -eq 'Valid') {
            "Signed: $path"
        } else {
            "Unsigned: $path"
        }
    } catch {
        "Deleted: $path"
    }
}

# Sortieren und speichern
$results | Sort-Object -Descending | Out-File -FilePath $OutFile

"Done"

