@echo off
setlocal EnableDelayedExpansion

set "BDIR=%~dp0"
set "PS1=%TEMP%\__cvt_%RANDOM%.ps1"

(
echo $root = '!BDIR!'
echo $soffice = 'C:\Program Files\LibreOffice\program\soffice.bin'
echo $pandoc = Join-Path $env:LOCALAPPDATA 'Pandoc\pandoc.exe'
echo.
echo function ConvertDocx^($file^) {
echo     $dir = Split-Path $file -Parent
echo     $name = [IO.Path]::GetFileNameWithoutExtension^($file^)
echo     ^& $pandoc $file -o ^(Join-Path $dir ^($name + '.md'^)^) --wrap=none --from docx --to markdown 2^>$null
echo     $arg = '--headless --norestore --nofirststartwizard --convert-to pdf "{0}" --outdir "{1}"' -f $file, $dir
echo     Start-Process -Wait -NoNewWindow -FilePath $soffice -ArgumentList $arg
echo }
echo.
echo Get-ChildItem $root -Filter '*.docx' -File ^| ForEach-Object { ConvertDocx $_.FullName }
echo Get-ChildItem $root -Directory ^| ForEach-Object {
echo     Get-ChildItem $_.FullName -Filter '*.docx' -File ^| ForEach-Object { ConvertDocx $_.FullName }
echo }
) > "%PS1%"

powershell -ExecutionPolicy Bypass -NonInteractive -File "%PS1%"
del "%PS1%" 2>nul
exit /b 0
