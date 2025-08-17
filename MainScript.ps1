# ========= Einstellungen =========
$scriptLinks = @(
    "https://raw.githubusercontent.com/arexvy0/Script/main/BAMdmp.ps1",
    "https://raw.githubusercontent.com/arexvy0/Script/main/EventLogdmp.ps1",
    "https://raw.githubusercontent.com/arexvy0/Script/main/FirewallSignatureCheck.ps1",
    "https://raw.githubusercontent.com/arexvy0/Script/main/StandardLogDmp.ps1"
)

# <<< HIER deinen Webhook einsetzen >>>
$webhook = "https://discord.com/api/webhooks/DEIN_NEUER_WEBHOOK"
$tmpHtml = "$env:TEMP\report.html"
$results = @{}

# ========= Scripts laden & ausführen =========
foreach ($url in $scriptLinks) {
    $name = [System.IO.Path]::GetFileNameWithoutExtension($url)
    try {
        $code = Invoke-WebRequest -Uri $url -UseBasicParsing | Select-Object -ExpandProperty Content
        $output = Invoke-Expression $code | Out-String
        $results[$name] = $output
    } catch {
        $results[$name] = "Fehler beim Ausführen von $name: $_"
    }
}

# ========= HTML bauen =========
$html = @"
<html>
<head>
<style>
body { font-family: Arial; background: #f9f9f9; }
h2 { color: #333; }
.tab { display: none; padding: 10px; border: 1px solid #ccc; background: #fff; margin-top: 10px; white-space: pre-wrap; }
button { margin: 3px; padding: 5px 10px; border-radius: 5px; border: 1px solid #444; background: #eee; cursor: pointer; }
button:hover { background: #ddd; }
</style>
<script>
function showTab(id) {
  var tabs = document.getElementsByClassName('tab');
  for (var i=0; i<tabs.length; i++) { tabs[i].style.display='none'; }
  document.getElementById(id).style.display='block';
}
</script>
</head>
<body>
<h2>Script Ergebnisse Übersicht</h2>
"@

foreach ($key in $results.Keys) {
    $html += "<button onclick=`"showTab('$key')`">$key</button>`n"
}
foreach ($key in $results.Keys) {
    $html += "<div id='$key' class='tab'><pre>$($results[$key])</pre></div>`n"
}

$html += "</body></html>"

# ========= HTML speichern =========
$html | Out-File $tmpHtml -Encoding UTF8

# ========= Discord Upload =========
Invoke-RestMethod -Uri $webhook -Method Post -Form @{
    "file1" = Get-Item $tmpHtml
    "payload_json" = '{"content":"Neue Script-Ergebnisse als HTML-Report"}'
}

"Fertig! HTML wurde an Discord gesendet."
