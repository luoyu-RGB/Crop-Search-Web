# run_ocr.ps1 —— 调用系统自带 Windows OCR 引擎，对 work\pages\page-*.png 做中文识别。
# 依赖：work\CropOcr.dll（由 build_ocr.ps1 编译生成）。全程离线。
param(
    [string]$PagesDir = (Join-Path $PWD 'work\pages'),
    [string]$OutDir = (Join-Path $PWD 'work\ocr'),
    [string]$LanguageTag = 'zh-Hans-CN',
    [int[]]$Pages = @()
)

$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# 从字节加载，避免工作目录被 .NET 判定为“网络位置”而拒绝加载程序集
if (-not ('CropOcr.Ocr' -as [type])) {
    $bytes = [System.IO.File]::ReadAllBytes((Join-Path $PWD 'work\CropOcr.dll'))
    $null = [System.Reflection.Assembly]::Load($bytes)
}
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$files = Get-ChildItem -Path $PagesDir -Filter 'page-*.png' | Sort-Object Name
if ($Pages.Count -gt 0) {
    $files = $files | Where-Object { $Pages -contains [int]($_.BaseName -replace 'page-', '') }
}

foreach ($f in $files) {
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $fullText = ''
    $lines = [CropOcr.Ocr]::Recognize($f.FullName, $LanguageTag, [ref]$fullText)
    $text = ($lines | ForEach-Object { $_.Text }) -join "`r`n"

    $utf8 = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText((Join-Path $OutDir ($f.BaseName + '.txt')), $text, $utf8)
    [System.IO.File]::WriteAllText((Join-Path $OutDir ($f.BaseName + '.raw.txt')), $fullText, $utf8)

    $sw.Stop()
    Write-Host ("{0} lines={1} chars={2} ms={3}" -f $f.Name, $lines.Count, $text.Length, $sw.ElapsedMilliseconds)
}
