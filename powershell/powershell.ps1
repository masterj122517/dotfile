
# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding
# PSReadLine
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineOption -PredictionSource History

$omp_config = Join-Path $PSScriptRoot ".\takuya.omp.json"

# Alias
Set-Alias vi nvim
Set-Alias ll ls
# oh-my-posh init pwsh | Invoke-Expression
oh-my-posh init pwsh --config $omp_config | Invoke-Expression
Import-Module posh-git
Import-Module -Name Terminal-Icons
# fzf
Import-Module PSFzf

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

# Utilities
function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}
