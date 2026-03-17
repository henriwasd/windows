# Notebook Setup Script
# Run this once on your notebook to sync everything

Write-Host "Checking dependencies..." -ForegroundColor Cyan
if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Oh My Posh..."
    winget install JanDeDobbeleer.OhMyPosh -e --accept-source-agreements --accept-package-agreements
}
if (-not (Get-Command zoxide -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Zoxide..."
    winget install ajeetdsouza.zoxide -e --accept-source-agreements --accept-package-agreements
}
if (-not (Get-Module -ListAvailable Terminal-Icons)) {
    Write-Host "Installing Terminal-Icons..."
    Install-Module -Name Terminal-Icons -Repository PSGallery -Force -SkipPublisherCheck
}

# Create Profile Directory if it doesn't exist
$profileDir = if ($PSVersionTable.PSEdition -eq "Core") { "$HOME\Documents\PowerShell" } else { "$HOME\Documents\WindowsPowerShell" }
if (-not (Test-Path $profileDir)) { New-Item -ItemType Directory -Path $profileDir -Force }

# Download Profile and Theme from GitHub
Write-Host "Downloading profile and theme..." -ForegroundColor Cyan
$repoUrl = "https://raw.githubusercontent.com/henriwasd/windows-terminal/main"
Invoke-RestMethod "$repoUrl/Microsoft.PowerShell_profile.ps1" | Out-File "$profileDir\Microsoft.PowerShell_profile.ps1" -Force
Invoke-RestMethod "$repoUrl/gruvbox.omp.json" | Out-File "$profileDir\gruvbox.omp.json" -Force

Write-Host "Done! Restart your PowerShell." -ForegroundColor Green
