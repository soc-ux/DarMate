
cd "$PSScriptRoot\..\infra"
terraform destroy -auto-approve

$dateStr = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Add-Content -Path "$PSScriptRoot\..\docs\journal-destructions.md" -Value "| $dateStr | terraform destroy | OK - 0 ressource restante |"

Write-Host "`nDestruction terminee avec succes" -ForegroundColor Green
