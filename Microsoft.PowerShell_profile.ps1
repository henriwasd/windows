# ==============================================================================
# PERFIL MINIMALISTA E ULTRA-RÁPIDO (POWERSHELL 7)
# ==============================================================================

# 1. Checagem Única de Administrador (Executada 1x na inicialização)
$global:IsAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
$global:PromptSymbol = if ($global:IsAdmin) { "#" } else { "$" }

# 2. PSReadLine (Histórico e Auto-completar inteligente)
if ($Host.Name -eq 'ConsoleHost' -and (Get-Module -ListAvailable PSReadLine)) {
    $PSReadLineOptions = @{
        EditMode                      = 'Windows'
        HistoryNoDuplicates           = $true
        HistorySearchCursorMovesToEnd = $true
        PredictionSource              = 'History'
        PredictionViewStyle           = 'ListView'
        BellStyle                     = 'None'
    }
    try { Set-PSReadLineOption @PSReadLineOptions } catch { }
    
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
}

# 3. Aliases Rápidos de Git (sem conflitos com os aliases nativos do PowerShell)
foreach ($aliasName in @('gc', 'ga', 'gs', 'gp', 'gpl', 'gps', 'gpu')) {
    if (Test-Path "Alias:$aliasName") { Remove-Item "Alias:$aliasName" -Force }
}

function ga { if ($args) { git add $args } else { git add . } }
function gc {
    if ($args.Count -eq 1 -and $args[0] -notlike "-*") {
        git commit -m $args[0]
    } else {
        git commit $args
    }
}
function gs { git status $args }
function gp { git pull $args }
function gpl { git pull $args }
function gpu { git push $args }
function gps { git push $args }

function touch($file) { "" | Out-File $file -Encoding ASCII }

# 4. Prompt Instantâneo (Sem processos externos)
function prompt {
    $currentPath = $ExecutionContext.SessionState.Path.CurrentLocation.ProviderPath
    $homePath = $HOME

    if ($currentPath -like "$homePath*") {
        $path = $currentPath -replace [regex]::Escape($homePath), "~"
    } else {
        $path = Split-Path $currentPath -Leaf
        if ($path -eq "") { $path = $currentPath }
    }

    $gitBranch = ""
    if (Test-Path ".git/HEAD") {
        try {
            $headContent = Get-Content ".git/HEAD" -TotalCount 1 -ErrorAction SilentlyContinue
            if ($headContent -match 'ref: refs/heads/(.+)') {
                $gitBranch = " (" + $matches[1] + ")"
            }
        } catch {}
    }

    return "[$path]$gitBranch $global:PromptSymbol "
}

# 5. Zoxide (Navegação rápida de pastas)
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (&zoxide init powershell | Out-String)
}
