$env:LANG = "en_US.UTF-8"

$coreutils = @("rm", "cp", "mv")
foreach ($cmd in $coreutils) {
  if (Test-Path "alias:$cmd") {
    Remove-Item "alias:$cmd" -Force
  }

  $functionName = $cmd
  $functionBody = {
    coreutils $MyInvocation.MyCommand.Name @args
  }.GetNewClosure()

  Set-Item "function:$functionName" $functionBody
}

Set-Alias ls eza
Set-Alias cat bat
Set-Alias grep rg
Set-Alias vi nvim
