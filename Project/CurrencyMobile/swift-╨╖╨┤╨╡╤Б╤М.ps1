# Запуск swift на этой машине.
#
# На Windows Swift не работает сам по себе: ему нужен компоновщик
# и библиотеки от Visual Studio. Их подключает vcvars64.bat.
# Плюс нужна переменная SDKROOT — без неё компилятор не находит
# стандартную библиотеку и падает с «unable to load standard
# library», что звучит как поломка установки, хотя дело только
# в переменной.
#
# На Mac ничего этого не нужно: Xcode делает всё сам. Этот файл —
# только для проверки ядра здесь.
#
#     .\swift-здесь.ps1 build
#     .\swift-здесь.ps1 test
param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Args)

$here   = Split-Path -Parent $MyInvocation.MyCommand.Path
$sdk    = [System.Environment]::GetEnvironmentVariable("SDKROOT", "User")
$swift  = "C:\Users\$env:USERNAME\AppData\Local\Programs\Swift\Toolchains\6.4.2+Asserts\usr\bin"
$rt     = "C:\Users\$env:USERNAME\AppData\Local\Programs\Swift\Runtimes\6.4.2\usr\bin"
$vcvars = "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
$inst   = "C:\Program Files (x86)\Microsoft Visual Studio\Installer"

#  Сборка идёт в папке с латинским путём. SwiftPM на Windows
#  спотыкается о кириллицу в пути: падает с «output.json doesn't
#  exist in file system», хотя дело вовсе не в файле.
$work = "C:\currency-swift-build"

$команда = ($Args -join " ")
if (-not $команда) { $команда = "build" }

$полная = "set `"SDKROOT=$sdk`" && " +
          "set `"PATH=$inst;$swift;$rt;%PATH%`" && " +
          "call `"$vcvars`" >nul && " +
          "cd /d `"$here`" && " +
          "swift $команда --scratch-path `"$work`" 2>&1"
cmd /c $полная
