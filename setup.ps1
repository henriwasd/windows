# Minimalist PowerShell Setup Script

Write-Host "Iniciando configuracao completa..."

# 1. Garantir que o PSReadLine esteja presente e atualizado (para o historico)
if (-not (Get-Module -ListAvailable PSReadLine)) {
    Write-Host "Instalando PSReadLine para suporte a historico..."
    Install-Module -Name PSReadLine -Force -AllowClobber -Scope CurrentUser
}

# 2. Instalar ferramentas adicionais via winget
$tools = @(
    @{ Name = "zoxide"; Id = "ajeetdsouza.zoxide" },
    @{ Name = "eza"; Id = "eza-community.eza" },
    @{ Name = "lazygit"; Id = "JesseDuffield.lazygit" },
    @{ Name = "yazi"; Id = "sxyazi.yazi" }
)

foreach ($tool in $tools) {
    if (-not (Get-Command $tool.Name -ErrorAction SilentlyContinue)) {
        Write-Host "Instalando $($tool.Name)..."
        winget install --id $tool.Id --silent --accept-package-agreements --accept-source-agreements
    } else {
        Write-Host "$($tool.Name) ja esta instalado."
    }
}

# 3. Localizar os diretorios do perfil do PowerShell (Windows PowerShell e Core)
$profileDirs = @(
    (Join-Path $HOME "Documents\WindowsPowerShell"),
    (Join-Path $HOME "Documents\PowerShell")
)

foreach ($dir in $profileDirs) {
    if (-not (Test-Path $dir)) { 
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }

    # 4. Copiar o perfil atual para o local correto do sistema
    Write-Host "Vinculando perfil otimizado em: $dir"
    $localProfile = Join-Path $PSScriptRoot "Microsoft.PowerShell_profile.ps1"
    $targetProfile = Join-Path $dir "Microsoft.PowerShell_profile.ps1"

    if (Test-Path $localProfile) {
        Copy-Item -Path $localProfile -Destination $targetProfile -Force
        Write-Host "Perfil instalado com sucesso em: $targetProfile"
    } else {
        Write-Error "Arquivo Microsoft.PowerShell_profile.ps1 nao encontrado no diretorio atual."
    }
}

Write-Host "Pronto! Reinicie o seu terminal para aplicar as mudancas."
