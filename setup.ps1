# ==============================================================================
# SCRIPT DE SETUP MINIMALISTA (WINDOWS / POWERSHELL & VSC)
# ==============================================================================

Write-Host "Iniciando configuracao minimalista..." -ForegroundColor Cyan

# 1. Garantir que o PSReadLine esteja instalado (para historico e auto-complete)
if (-not (Get-Module -ListAvailable PSReadLine)) {
    Write-Host "Instalando PSReadLine..." -ForegroundColor Yellow
    Install-Module -Name PSReadLine -Force -AllowClobber -Scope CurrentUser
}

# 2. Instalar apenas o Zoxide via Winget
if (-not (Get-Command zoxide -ErrorAction SilentlyContinue)) {
    Write-Host "Instalando Zoxide..." -ForegroundColor Yellow
    winget install --id ajeetdsouza.zoxide --silent --accept-package-agreements --accept-source-agreements
} else {
    Write-Host "Zoxide ja esta instalado." -ForegroundColor Green
}

# 3. Copiar o perfil otimizado do PowerShell (PowerShell 7 e Windows PowerShell 5.1)
$profileDirs = @(
    (Join-Path $HOME "Documents\WindowsPowerShell"),
    (Join-Path $HOME "Documents\PowerShell")
)

$localProfile = Join-Path $PSScriptRoot "Microsoft.PowerShell_profile.ps1"

foreach ($dir in $profileDirs) {
    if (-not (Test-Path $dir)) { 
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }

    $targetProfile = Join-Path $dir "Microsoft.PowerShell_profile.ps1"

    if (Test-Path $localProfile) {
        Copy-Item -Path $localProfile -Destination $targetProfile -Force
        Write-Host "Perfil copiado com sucesso para: $targetProfile" -ForegroundColor Green
    } else {
        Write-Warning "Arquivo Microsoft.PowerShell_profile.ps1 nao encontrado no diretorio atual."
    }
}

Write-Host "Setup concluido com sucesso!" -ForegroundColor Cyan
