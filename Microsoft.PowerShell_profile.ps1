# Perfil Otimizado - Foco em Performance e Histórico

# 1. Configuração do PSReadLine
if (Get-Module -ListAvailable PSReadLine) {
    $PSReadLineOptions = @{
        EditMode                      = 'Windows'
        HistoryNoDuplicates           = $true
        HistorySearchCursorMovesToEnd = $true
        PredictionSource              = 'History'
        PredictionViewStyle           = 'ListView'
        BellStyle                     = 'None'
    }
    Set-PSReadLineOption @PSReadLineOptions
    
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
}

# 2. Prompt Minimalista sem Cores
function prompt {
    $path = $ExecutionContext.SessionState.Path.CurrentLocation
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    $symbol = if ($isAdmin) { "#" } else { "$" }
    
    # Git Info sem cores
    $gitInfo = ""
    if (Get-Command git -ErrorAction SilentlyContinue) {
        $branch = git branch --show-current 2>$null
        if ($branch) {
            $status = git status --porcelain 2>$null
            $indicators = ""
            if ($status -match '^[MADRCU]') { $indicators += "+" }
            if ($status -match '^.[MADRCU]') { $indicators += "!" }
            if ($status -match '^\?\?')       { $indicators += "?" }
            $gitInfo = " ($branch$indicators)"
        }
    }
    
    return "[$path]$gitInfo $symbol "
}

# 3. Aliases
Set-Alias -Name ep -Value Edit-Profile
function Edit-Profile { notepad $PROFILE }
function pj { Set-Location "$HOME\Projects" }
function ga { git add . }
function gc { param($m) git commit -m "$m" }
function gs { git status }
function touch($file) { "" | Out-File $file -Encoding ASCII }
