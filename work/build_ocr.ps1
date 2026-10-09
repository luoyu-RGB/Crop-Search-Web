# build_ocr.ps1 —— 使用 .NET Framework 自带的 csc 编译 work\CropOcr.cs 为 CropOcr.dll。
$ErrorActionPreference = 'Stop'
$csc = 'C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe'
$src = Join-Path $PWD 'work\CropOcr.cs'
$out = Join-Path $PWD 'work\CropOcr.dll'

& $csc /nologo /target:library /platform:x64 /optimize+ /unsafe+ /out:$out $src
if ($LASTEXITCODE -ne 0) { throw "csc 编译失败，退出码 $LASTEXITCODE" }
Write-Host ("BUILD OK -> {0} ({1} bytes)" -f $out, (Get-Item $out).Length)
