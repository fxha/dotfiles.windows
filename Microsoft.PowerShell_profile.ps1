#######################################
# Modules and Scripts
#

Import-Module Get-ChildItemColor
Import-Module PSReadLine
Import-Module posh-git
Import-Module posh-sshell


###################
# PSReadLine

Set-PSReadLineOption -HistoryNoDuplicates
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -HistorySaveStyle SaveIncrementally
Set-PSReadLineOption -MaximumHistoryCount 2000
Set-PSReadlineOption -BellStyle Visual
Set-PSReadLineOption -PredictionSource None

# History substring search
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# Tab completion
Set-PSReadlineKeyHandler -Chord Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Chord 'Shift+Tab' -Function Complete

#######################################
# Environment
#

# $env:Path += ";${env:USERNAME}\.bin"


#######################################
# Git
#

$env:GIT_SSH="C:\Windows\System32\OpenSSH\ssh.exe"
Set-Alias ssh-agent "C:\Windows\System32\OpenSSH\ssh.exe"
Set-Alias ssh-add "C:\Windows\System32\OpenSSH\ssh.exe"

Start-SshAgent -Quiet


#######################################
# Aliases
#

# Colored ls -la
Set-Alias ls Get-ChildItem -Force -option AllScope

Set-Alias g git
Set-Alias grep findstr
Set-Alias ll ls

Set-Alias edit code
# Set-Alias vim "C:\Program Files\Git\usr\bin\vim.exe"


#######################################
# Functions
#

function .. { cd .. }
function ... { cd .. ; cd .. }
function .... { cd .. ; cd .. ; cd .. }
function ..... { cd .. ; cd .. ; cd .. ; cd .. }
function home { cd $env:USERPROFILE }

function mkcd($path) {
  New-Item $path -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
  Set-Location $path
}

function egrep($regex) {
  $input | where-object { $_.Contains($regex) }
}

function ln($target, $link) {
  New-Item -ItemType SymbolicLink -Path $link -Value $target
}

function open($file) {
  Invoke-Item $file
}

function pkill($name) {
  Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}

function pgrep($name) {
  Get-Process $name
}

function sudo() {
  Invoke-Elevated @args
}

function time {
  $Command = "$args"
  Measure-Command { Invoke-Expression $Command 2>&1 | out-default }
}

function touch($file) {
  if($file -eq $null) {
    throw "No filename supplied"
  }

  if(Test-Path $file) {
    (Get-ChildItem $file).LastWriteTime = Get-Date
  } else {
    Set-Content -Path ($file) -Value ($null)
  }
}

function which($command) {
  Get-Command $command | Select-Object -ExpandProperty Definition
}


#######################################
# Prompt
#

function Test-Administrator {
  $currentUser = [Security.Principal.WindowsPrincipal]([Security.Principal.WindowsIdentity]::GetCurrent())
  return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

$GitPromptSettings.DefaultPromptBeforeSuffix.Text = "`n"
$GitPromptSettings.PathStatusSeparator.Text = " "
$GitPromptSettings.DefaultPromptSuffix.Text = "$("$" * ($nestedPromptLevel + 1)) "
$GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $false
$GitPromptSettings.DefaultPromptPath.ForegroundColor = [System.ConsoleColor]::Blue
$GitPromptSettings.DefaultPromptPrefix.Text = "$(if (Test-Administrator) {'^'})${env:USERNAME}@${env:COMPUTERNAME} "
$GitPromptSettings.DefaultPromptPrefix.ForegroundColor = [System.ConsoleColor]::DarkGreen # DarkYellow
