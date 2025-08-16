# Löschen der Ordner
Remove-Item "C:\temp\eventlogs", "C:\temp\journal", "C:\temp\others", "C:\temp\reg", "C:\temp\Standard Logs" -Recurse -Force -ErrorAction SilentlyContinue

# Zwischenablage leeren
Set-Clipboard -Value $null

# Konsole leeren
Clear-Host

# PSReadLine-History löschen
$historyPath = "C:\Users\$env:USERNAME\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"
if (Test-Path $historyPath) {
    Clear-Content -Path $historyPath -Force
