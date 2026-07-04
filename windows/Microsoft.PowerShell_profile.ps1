[System.Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding("utf-8")
[System.Console]::InputEncoding = [System.Text.Encoding]::GetEncoding("utf-8")
$env:LANG = "en_US.UTF-8"
$env:LESSCHARSET = "utf-8"
$env:PYTHONUTF8 = "1"
$env:PYTHONIOENCODING = "utf-8"

function which($cmdname) {
	Get-Command $cmdname -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Definition
}

Set-Alias ls eza -Option AllScope -Force
Set-Alias cat bat -Option AllScope -Force
Set-Alias grep rg
Set-Alias diff delta -Option AllScope -Force
Set-Alias vi nvim

# recent dirs (zsh cdr 相当): ディレクトリ移動を記録し、Ctrl+e で候補から cd
$global:RecentDirsFile = "$env:USERPROFILE\.cache\recent-dirs"

function Update-RecentDirs {
	$dir = (Get-Location).Path
	if ($dir -eq $global:LastRecentDir) { return }
	$global:LastRecentDir = $dir

	New-Item -ItemType Directory -Force (Split-Path $global:RecentDirsFile) | Out-Null
	$dirs = @($dir) + @(if (Test-Path $global:RecentDirsFile) { Get-Content $global:RecentDirsFile })
	$dirs | Where-Object { $_ } | Select-Object -Unique -First 1000 | Set-Content $global:RecentDirsFile
}

if ($PSVersionTable.PSVersion -ge [version]'6.2') {
	$ExecutionContext.SessionState.InvokeCommand.LocationChangedAction = { Update-RecentDirs }
}

Set-PSReadLineKeyHandler -Chord Ctrl+e -ScriptBlock {
	if (!(Test-Path $global:RecentDirsFile)) {
	  return
	}

	$dir = Get-Content $global:RecentDirsFile | fzf --prompt='cd > ' --reverse --border --inline-info --preview 'eza -hl --color=always --icons=always {}'

	if (!$dir) {
	  return
	}

	[Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
	[Microsoft.PowerShell.PSConsoleReadLine]::Insert("cd '" + ($dir -replace "'", "''") + "'")
	[Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}

Set-PSReadLineKeyHandler -Chord Ctrl+r -ScriptBlock {
	$lines = @(Get-Content (Get-PSReadlineOption).HistorySavePath)
	[array]::Reverse($lines)
	$seen = [System.Collections.Generic.HashSet[string]]::new()
	$command = $lines.Where({ $seen.Add($_) }) | fzf --reverse --border --inline-info

	if (!$command) {
	  return
	}

	[Microsoft.PowerShell.PSConsoleReadLine]::Insert($command)
}
