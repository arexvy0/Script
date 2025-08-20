# Zielpfad im Download-Ordner
$outFile = "$env:USERPROFILE\Downloads\PCA_Events.txt"

"==== PCA EVENT LOG EXPORT ====" | Out-File -FilePath $outFile -Encoding UTF8

# Alle relevanten Log-Kanäle (aus deiner Liste)
$logNames = @(
    "Microsoft-Windows-Application-Experience/Program-Compatibility-Assistant",
    "Microsoft-Windows-Application-Experience/Program-Compatibility-Troubleshooter",
    "Microsoft-Windows-WinHttp-Pca",
    "Microsoft-Windows-WinINet/Pca"
)

foreach ($log in $logNames) {
    "---- Events from: $log ----" | Out-File -FilePath $outFile -Append -Encoding UTF8
    try {
        Get-WinEvent -LogName $log -MaxEvents 50 -ErrorAction Stop |
            Select-Object TimeCreated, Id, LevelDisplayName, Message |
            Out-String -Width 300 |
            Out-File -FilePath $outFile -Append -Encoding UTF8
    } catch {
        "Keine Daten oder Zugriff verweigert." | Out-File -FilePath $outFile -Append -Encoding UTF8
    }
    "`n" | Out-File -FilePath $outFile -Append -Encoding UTF8
}

Write-Output "Export abgeschlossen! Datei gespeichert unter: $outFile"
