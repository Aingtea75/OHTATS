Set-Location "C:\Users\hend\OHTATS"

Write-Host "=== OHTATS SYNC ===" -ForegroundColor Cyan
git status

Write-Host "`nMengambil perubahan dari GitHub..." -ForegroundColor Yellow
git fetch origin

Write-Host "`nMenyinkronkan master dengan origin/master..." -ForegroundColor Yellow
git pull --ff-only origin master

Write-Host "`n=== HASIL ===" -ForegroundColor Green
git status
