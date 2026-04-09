$obsPath = "$env:APPDATA\obs-studio"
$backupFile = "$PSScriptRoot\backup_obs_studio.zip"

if (Test-Path $obsPath) {
    Write-Host "Backup local ja existe. Fazendo backup anterior por seguranca..." -ForegroundColor Yellow
    Rename-Item -Path $obsPath -NewName ("obs-studio_old_" + (Get-Date -Format "yyyyMMdd_HHmmss")) -ErrorAction SilentlyContinue
}

Write-Host "Restaurando configuracoes do OBS..." -ForegroundColor Cyan
Expand-Archive -Path $backupFile -DestinationPath $env:APPDATA -Force
Write-Host "Configuracoes restauradas com sucesso!" -ForegroundColor Green
