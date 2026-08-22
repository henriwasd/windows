$obsPath = "$env:APPDATA\obs-studio"
$backupFile = "$PSScriptRoot\backup_obs_studio.zip"

if (-not (Test-Path $obsPath)) {
    Write-Host "Pasta do OBS Studio nao encontrada em $obsPath!" -ForegroundColor Red
    exit 1
}

$wasRunning = $false
if (Get-Process -Name "obs64" -ErrorAction SilentlyContinue) {
    $wasRunning = $true
    Write-Host "Fechando OBS temporariamente para garantir backup limpo..." -ForegroundColor Yellow
    Stop-Process -Name "obs64" -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 1
}

Write-Host "Gerando backup otimizado do OBS Studio (sem caches temporarios)..." -ForegroundColor Cyan
if (Test-Path $backupFile) {
    Remove-Item -Path $backupFile -Force
}

$tempDir = Join-Path $env:TEMP ("obs-backup-temp-" + (Get-Date -Format "yyyyMMdd_HHmmss"))
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

# Copiar arquivos do OBS ignorando caches temporarios do navegador, logs e crashes
$excludePatterns = @("logs", "crashes", ".sentinel", "Code Cache", "Cache", "GPUCache", "DawnCache", "ShaderCache", "GrShaderCache", "DawnWebGPUCache", "DawnGraphiteCache", "GraphiteDawnCache", "WidevineCdm", "component_crx_cache")

Copy-Item -Path "$obsPath\*" -Destination $tempDir -Recurse -Force -ErrorAction SilentlyContinue

foreach ($pattern in $excludePatterns) {
    Get-ChildItem -Path $tempDir -Recurse -Include $pattern -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
}

Compress-Archive -Path "$tempDir\*" -DestinationPath $backupFile -Force
Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue

$zipSize = (Get-Item $backupFile).Length / 1MB
Write-Host ("Backup do OBS salvo com sucesso! Tamanho final: {0:N2} MB" -f $zipSize) -ForegroundColor Green

if ($wasRunning) {
    Write-Host "Reiniciando OBS..." -ForegroundColor Cyan
    Start-Process -FilePath "C:\Program Files\obs-studio\bin\64bit\obs64.exe" -ArgumentList "--startreplaybuffer --minimize-to-tray --disable-shutdown-check --disable-safe-mode --disable-missing-files" -WorkingDirectory "C:\Program Files\obs-studio\bin\64bit"
}
