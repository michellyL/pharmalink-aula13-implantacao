param(
    [Parameter(Mandatory=$true)][string]$JarName
)
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$artifact = Join-Path (Join-Path $root "artefatos") $JarName
if (!(Test-Path $artifact)) { throw "Artefato não encontrado: $artifact" }

$homolog = Join-Path (Join-Path $root "homolog") $JarName
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $homolog) | Out-Null
Copy-Item $artifact $homolog -Force

$hashHomolog = (Get-FileHash $homolog -Algorithm SHA256).Hash
Write-Host "Hash HOMOLOG: $hashHomolog"
Write-Host "ATENÇÃO: só promova após os testes técnicos e funcionais de HOMOLOG passarem."
$approval = Read-Host "Digite APROVAR somente se os testes passaram e houve autorização"
if ($approval -cne "APROVAR") { throw "Promoção cancelada; não foi registrada aprovação." }

$prodDir = Join-Path $root "prod"
$backupDir = Join-Path $root "backup"
New-Item -ItemType Directory -Force -Path $prodDir,$backupDir | Out-Null
if (Test-Path (Join-Path $prodDir $JarName)) {
    Copy-Item (Join-Path $prodDir $JarName) $backupDir -Force
}
Copy-Item $homolog (Join-Path $prodDir $JarName) -Force
$hashProd = (Get-FileHash (Join-Path $prodDir $JarName) -Algorithm SHA256).Hash
Write-Host "Hash PROD:    $hashProd"
if ($hashHomolog -ne $hashProd) { throw "Hash divergente! Interrompa e investigue." }
Write-Host "Hash igual. Ainda é obrigatório executar o teste técnico e funcional em PROD simulada."
