New-Item -ItemType Directory -Path C:\temp | Out-Null
New-Item -ItemType Directory -Path C:\temp\Reg | Out-Null
New-Item -ItemType Directory -Path C:\temp\eventlogs | Out-Null
Set-Location C:\temp\eventlogs\

"`n420: Volume Deleted`n" | Out-File "C_Volumes.txt" -Append
Get-WinEvent -MaxEvents 30 -FilterHashtable @{LogName="Microsoft-Windows-Kernel-PnP/Configuration"; ID=420} |
    Select-Object TimeCreated, Id, Message | Out-File "C_Volumes.txt" -Append

"`n410: Volume Created`n" | Out-File "C_Volumes.txt" -Append
Get-WinEvent -MaxEvents 30 -FilterHashtable @{LogName="Microsoft-Windows-Kernel-PnP/Configuration"; ID=410} |
    Select-Object TimeCreated, Id, Message | Out-File "C_Volumes.txt" -Append

"`n400: Device configured`n" | Out-File "C_Volumes.txt" -Append
Get-WinEvent -MaxEvents 30 -FilterHashtable @{LogName="Microsoft-Windows-Kernel-PnP/Configuration"; ID=400} |
    Select-Object TimeCreated, Id, Message | Out-File "C_Volumes.txt" -Append

"`n517: The audit log was cleared`n" | Out-File "EC_Eventlogs.txt" -Append
Get-EventLog -LogName Security | Where-Object { $_.EventID -eq 517 } |
    Select-Object TimeWritten, EntryType, EventID, Message | Out-File "EC_Eventlogs.txt" -Append

"`n1102: The audit log was cleared`n" | Out-File "EC_Eventlogs.txt" -Append
Get-EventLog -LogName Security | Where-Object { $_.EventID -eq 1102 } |
    Select-Object TimeWritten, EntryType, EventID, Message | Out-File "EC_Eventlogs.txt" -Append

"`n6005: The audit log was started`n" | Out-File "EC_Eventlogs.txt" -Append
Get-EventLog -LogName System -Newest 2000 | Where-Object { $_.EventID -eq 6005 } |
    Select-Object TimeWritten, EntryType, EventID, Message | Out-File "EC_Eventlogs.txt" -Append

"`n6006: The audit log was interrupted (should not be after 6005)`n" | Out-File "EC_Eventlogs.txt" -Append
Get-EventLog -LogName System -Newest 2000 | Where-Object { $_.EventID -eq 6006 } |
    Select-Object TimeWritten, EntryType, EventID, Message | Out-File "EC_Eventlogs.txt" -Append

"`n1001: Application Hang or Crashed`n" | Out-File "C_Crashes.txt" -Append
Get-EventLog -LogName Application -Newest 200 | Where-Object { $_.EventID -eq 1001 } |
    Select-Object TimeWritten, EntryType, EventID, Message | Out-File "C_Crashes.txt" -Append

"`n3079: The read journal was cleared`n" | Out-File "EC_Journal.txt" -Append
Get-EventLog -LogName Application | Where-Object { $_.EventID -eq 3079 } |
    Select-Object TimeWritten, EntryType, EventID, Message | Out-File "EC_Journal.txt" -Append

