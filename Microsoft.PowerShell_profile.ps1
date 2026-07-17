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

if (Get-Command eza -ErrorAction SilentlyContinue) {
    if (Test-Path Alias:ls) { Remove-Item Alias:ls }
    function ls { eza --icons $args }
    function ll { eza -l --icons --git $args }
}

if (Get-Command lazygit -ErrorAction SilentlyContinue) { function lg { lazygit $args } }

if (Get-Command yazi -ErrorAction SilentlyContinue) {
    function y {
        $tmp = New-TemporaryFile
        yazi $args --cwd-file=$tmp
        if (Test-Path $tmp) {
            $cwd = Get-Content $tmp
            if ($cwd) { cd $cwd }
            Remove-Item -Force $tmp
        }
    }
}

function prompt {
    $currentPath = $ExecutionContext.SessionState.Path.CurrentLocation.ProviderPath
    $homePath = $HOME

    if ($currentPath -like "$homePath*") {
        $path = $currentPath -replace [regex]::Escape($homePath), "~"
    }
    else {
        $path = Split-Path $currentPath -Leaf
        if ($path -eq "") { $path = $currentPath }
    }

    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    $symbol = if ($isAdmin) { "#" } else { "$" }
    
    $gitInfo = ""
    if (Get-Command git -ErrorAction SilentlyContinue) {
        $branch = git branch --show-current 2>$null
        if ($branch) {
            $status = git status --porcelain 2>$null
            $indicators = ""
            if ($status -match '^[MADRCU]') { $indicators += "+" }
            if ($status -match '^.[MADRCU]') { $indicators += "!" }
            if ($status -match '^\?\?') { $indicators += "?" }
            $gitInfo = " ($branch$indicators)"
        }
    }
    
    return "[$path]$gitInfo $symbol "
}

function ga { git add . }
function gc { param($m) git commit -m "$m" }
function gs { git status }
function touch($file) { "" | Out-File $file -Encoding ASCII }

if (Get-Command zoxide -ErrorAction SilentlyContinue) { Invoke-Expression (&zoxide init powershell | Out-String) }
