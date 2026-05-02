[System.Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding("utf-8")
[System.Console]::InputEncoding = [System.Text.Encoding]::GetEncoding("utf-8")
$env:LANG = "en_US.UTF-8"
$env:LESSCHARSET = "utf-8"
$env:PYTHONUTF8 = "1"
$env:PYTHONIOENCODING = "utf-8"

function which($cmdname) {
	Get-Command $cmdname -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Definition
}

Set-Alias ls eza
Set-Alias cat bat
Set-Alias grep rg
Set-Alias vi nvim
