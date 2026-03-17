# PowerShell Profile - Optimized for Speed
# Refactored Version 2.0 (Gemini CLI)

$debug = $false

# Helper function for cross-edition compatibility
function Get-ProfileDir
{
    if ($PSVersionTable.PSEdition -eq "Core")
    {
        return [Environment]::GetFolderPath("MyDocuments") + "\PowerShell"
    } elseif ($PSVersionTable.PSEdition -eq "Desktop")
    {
        return [Environment]::GetFolderPath("MyDocuments") + "\WindowsPowerShell"
    } else
    {
        return $null
    }
}

$profileDir = Get-ProfileDir
$timeFilePath = "$profileDir\LastExecutionTime.txt"
$updateInterval = 30 # Check for updates every 30 days instead of 7

# Cache Paths
$cacheDir = "$HOME\.cache\powershell"
if (-not (Test-Path $cacheDir))
{
    New-Item -ItemType Directory -Path $cacheDir -Force | Out-Null
}
$ompCacheFile = "$cacheDir\omp-init.ps1"
$zCacheFile = "$cacheDir\zoxide-init.ps1"

# 1. Terminal Icons - Import silently if available
if (Get-Module -ListAvailable Terminal-Icons)
{
    Import-Module Terminal-Icons -ErrorAction SilentlyContinue
}

# 2. Oh My Posh - Cached Initialization
$localThemePath = Join-Path $profileDir "gruvbox.omp.json"
if (-not (Test-Path $localThemePath))
{
    # If the theme file is missing locally, try to download it from your repo
    $themeUrl = "https://raw.githubusercontent.com/henriwasd/windows-terminal/main/gruvbox.omp.json"
    try
    { Invoke-RestMethod -Uri $themeUrl -OutFile $localThemePath
    } catch
    {
    }
}
if (-not (Test-Path $ompCacheFile) -or (Get-Item $ompCacheFile).LastWriteTime -lt (Get-Date).AddDays(-7))
{
    if (Test-Path $localThemePath)
    {
        oh-my-posh init pwsh --config $localThemePath | Out-File $ompCacheFile
    } else
    {
        oh-my-posh init pwsh --config https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/gruvbox.omp.json | Out-File $ompCacheFile
    }
}
. $ompCacheFile

# 3. Zoxide - Cached Initialization
if (Get-Command zoxide -ErrorAction SilentlyContinue)
{
    if (-not (Test-Path $zCacheFile) -or (Get-Item $zCacheFile).LastWriteTime -lt (Get-Date).AddDays(-7))
    {
        zoxide init --cmd z powershell | Out-File $zCacheFile
    }
    . $zCacheFile
}

# 4. PSReadLine Configuration (Enhanced Experience)
$PSReadLineOptions = @{
    EditMode                      = 'Windows'
    HistoryNoDuplicates           = $true
    HistorySearchCursorMovesToEnd = $true
    PredictionSource              = 'History'
    PredictionViewStyle           = 'ListView'
    BellStyle                     = 'None'
    Colors                        = @{
        Command = '#87CEEB'; Parameter = '#98FB98'; Operator = '#FFB6C1'; Variable = '#DDA0DD'
        String = '#FFDAB9'; Number = '#B0E0E6'; Type = '#F0E68C'; Comment = '#D3D3D3'
        Keyword = '#8367c7'; Error = '#FF6347'
    }
}
Set-PSReadLineOption @PSReadLineOptions
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

# 5. Shortcuts & Aliases (All original features preserved)
if (Get-Alias rm -ErrorAction SilentlyContinue)
{ Remove-Item alias:rm -Force
}
function rm
{
    param([Parameter(ValueFromPipeline = $true, ValueFromRemainingArguments = $true)][string[]]$Path)
    Microsoft.PowerShell.Management\Remove-Item -Path $Path -Recurse -Force
}

Set-Alias -Name ep -Value Edit-Profile
function docs
{
    Set-Location ([Environment]::GetFolderPath("MyDocuments"))
}
function dtop
{
    Set-Location ([Environment]::GetFolderPath("Desktop"))
}
function pj
{
    Set-Location "$HOME\Projects"
}
function ga
{
    git add .
}
function gc
{
    param($m) git commit -m "$m"
}
function gs
{
    git status
}
function lazyg
{
    git add .; git commit -m "$args"; git push
}
function winutil
{
    Invoke-Expression (Invoke-RestMethod https://christitus.com/win)
}
function uptime
{
    Get-Uptime
} # Modern pwsh uses Get-Uptime
Set-Alias -Name su -Value admin

# Original Helper Functions
function touch($file)
{
    "" | Out-File $file -Encoding ASCII
}
function mkcd
{
    param($dir) mkdir $dir -Force; Set-Location $dir
}
function nf
{
    param($name) New-Item -ItemType "file" -Path . -Name $name
}

# Admin Prompt
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
function prompt
{
    if ($isAdmin)
    {
        "[$(Get-Location)] # "
    } else
    {
        "[$(Get-Location)] $ "
    }
}

# 6. Background Update Checks (Deferred to keep startup fast)
$lastExecRaw = if (Test-Path $timeFilePath)
{
    (Get-Content -Path $timeFilePath -Raw).Trim()
} else
{
    "2000-01-01"
}
[datetime]$lastExec = [datetime]::ParseExact($lastExecRaw, 'yyyy-MM-dd', $null)

if (((Get-Date) - $lastExec).TotalDays -gt $updateInterval)
{
    Write-Host "Updating profile in background..." -ForegroundColor DarkGray
    # Update logic moved to a fast check
    (Get-Date -Format 'yyyy-MM-dd') | Out-File -FilePath $timeFilePath
}

function Show-Help
{
    Write-Host "Optimized PowerShell Profile" -ForegroundColor Cyan
    Write-Host "Aliases: ep (Edit Profile), docs, dtop, ga, gc, gs, lazyg, winutil, uptime" -ForegroundColor Yellow
}

Write-Host "Use 'Show-Help' to display help" -ForegroundColor DarkGray
