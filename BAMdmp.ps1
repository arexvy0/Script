# Ordner erstellen
New-Item -ItemType Directory -Path C:\temp | Out-Null
Set-Location C:\temp

# BAM1: ControlSet001
"`nBAM1 ControlSet001\Services\bam\State\UserSettings`n" | Out-File "BAM_Dump.txt" -Append
reg query "HKLM\SYSTEM\ControlSet001\Services\bam\State\UserSettings" /s |
    findstr /i /c:".exe" /c:".bat" /c:".zip" /c:".rar" | Out-File "BAM_Dump.txt" -Append

# BAM2: CurrentControlSet
"`nBAM2 CurrentControlSet\Services\bam`n" | Out-File "BAM_Dump.txt" -Append
reg query "HKLM\SYSTEM\CurrentControlSet\Services\bam" /s |
    findstr /i /c:".exe" /c:".bat" /c:".zip" /c:".rar" | Out-File "BAM_Dump.txt" -Append

# BAM3: CurrentControlSet State
"`nBAM3 CurrentControlSet\Services\bam\State`n" | Out-File "BAM_Dump.txt" -Append
reg query "HKLM\SYSTEM\CurrentControlSet\Services\bam\State" /s |
    findstr /i /c:".exe" /c:".bat" /c:".zip" /c:".rar" | Out-File "BAM_Dump.txt" -Append
