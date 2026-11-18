param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Args)

$here   = Split-Path -Parent $MyInvocation.MyCommand.Path
$sdk    = [System.Environment]::GetEnvironmentVariable("SDKROOT", "User")
$swift  = "C:\Users\$env:USERNAME\AppData\Local\Programs\Swift\Toolchains\6.4.2+Asserts\usr\bin"
$rt     = "C:\Users\$env:USERNAME\AppData\Local\Programs\Swift\Runtimes\6.4.2\usr\bin"
$vcvars = "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
$inst   = "C:\Program Files (x86)\Microsoft Visual Studio\Installer"

$work = "C:\currency-swift-build"

$команда = ($Args -join " ")
if (-not $команда) { $команда = "build" }

$полная = "set `"SDKROOT=$sdk`" && " +
          "set `"PATH=$inst;$swift;$rt;%PATH%`" && " +
          "call `"$vcvars`" >nul && " +
          "cd /d `"$here`" && " +
          "swift $команда --scratch-path `"$work`" 2>&1"
cmd /c $полная
