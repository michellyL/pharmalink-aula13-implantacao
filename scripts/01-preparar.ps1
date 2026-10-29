$ErrorActionPreference = "Stop"
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$folders = @("origem","artefatos","homolog","prod","backup","evidencias")
foreach ($folder in $folders) {
    New-Item -ItemType Directory -Force -Path (Join-Path $root $folder) | Out-Null
}
Write-Host "Pastas locais criadas em: $root"
$source = Join-Path $root "origem"
if (Test-Path (Join-Path $source ".git")) {
    Push-Location $source
    git branch --show-current
    git rev-parse --short HEAD
    Pop-Location
} else {
    Write-Host "AVISO: coloque uma cópia do projeto PharmaLink em '$source' para identificar branch e commit."
}
java -version
