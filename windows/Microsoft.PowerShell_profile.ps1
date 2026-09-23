[System.Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding("utf-8")
[System.Console]::InputEncoding = [System.Text.Encoding]::GetEncoding("utf-8")
$env:LANG = "en_US.UTF-8"
$env:LESSCHARSET = "utf-8"
$env:PYTHONUTF8 = "1"
$env:PYTHONIOENCODING = "utf-8"

function which($cmdname) {
	Get-Command $cmdname -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Definition
}

$env:EZA_ICON_SPACING = "2"
function Invoke-Eza { eza --git --bytes --group-directories-first --time-style=long-iso --icons=auto @args }
Set-Alias ls Invoke-Eza -Option AllScope -Force
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

# dotfiles update check (async): origin/master が先行していれば次のプロンプトで知らせる
$global:DotfilesDir         = "$env:USERPROFILE\dotfiles"
$global:DotfilesCheckResult = "$env:USERPROFILE\.cache\dotfiles_check_result"
$dotfilesCheckTs            = "$env:USERPROFILE\.cache\dotfiles_check_ts"

# 1 時間以内に確認済みならスキップ
if (-not (Test-Path $dotfilesCheckTs) -or ((Get-Date) - (Get-Item $dotfilesCheckTs).LastWriteTime).TotalSeconds -ge 3600) {
	New-Item -ItemType File -Force $dotfilesCheckTs | Out-Null
	Start-Job -ArgumentList $global:DotfilesDir, $global:DotfilesCheckResult {
		param($dir, $result)
		git -C $dir fetch origin --quiet 2>$null
		$behind = git -C $dir rev-list HEAD..origin/master --count 2>$null
		if ([int]$behind -gt 0) {
			"$([char]27)[33m[dotfiles]$([char]27)[0m $behind commit(s) behind origin/master. Run $([char]27)[36mgit pull$([char]27)[0m in $dir" | Set-Content $result
		}
	} | Out-Null
}

function prompt {
	if (Test-Path $global:DotfilesCheckResult) {
		Get-Content $global:DotfilesCheckResult | Write-Host
		Remove-Item $global:DotfilesCheckResult
	}
	"PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
}
