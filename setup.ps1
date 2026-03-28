# Minimalist PowerShell Setup Script

Write-Host "Iniciando configuracao minimalista..."

# 1. Garantir que o PSReadLine esteja presente e atualizado (para o historico)
if (-not (Get-Module -ListAvailable PSReadLine)) {
    Write-Host "Instalando PSReadLine para suporte a historico..."
    Install-Module -Name PSReadLine -Force -AllowClobber -Scope CurrentUser
}

# 2. Localizar o diretorio do perfil do PowerShell
$profileDir = if ($PSVersionTable.PSEdition -eq "Core") { 
    Join-Path $HOME "Documents\PowerShell" 
} else { 
    Join-Path $HOME "Documents\WindowsPowerShell" 
}

if (-not (Test-Path $profileDir)) { 
    New-Item -ItemType Directory -Path $profileDir -Force 
}

# 3. Copiar o perfil atual para o local correto do sistema
Write-Host "Vinculando perfil otimizado..."
$localProfile = Join-Path $PSScriptRoot "Microsoft.PowerShell_profile.ps1"
$targetProfile = Join-Path $profileDir "Microsoft.PowerShell_profile.ps1"

if (Test-Path $localProfile) {
    Copy-Item -Path $localProfile -Destination $targetProfile -Force
    Write-Host "Perfil instalado com sucesso em: $targetProfile"
} else {
    Write-Error "Arquivo Microsoft.PowerShell_profile.ps1 nao encontrado no diretorio atual."
}

Write-Host "Pronto! Reinicie o seu terminal para aplicar as mudancas."
