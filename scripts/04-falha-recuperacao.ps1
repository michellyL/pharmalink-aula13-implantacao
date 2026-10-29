param(
    [Parameter(Mandatory=$true)][string]$JarName
)
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$prodDir = Join-Path $root "prod"
$backupDir = Join-Path $root "backup"
$jar = Join-Path $prodDir $JarName
if (!(Test-Path $jar)) { throw "JAR não encontrado em PROD simulada: $jar" }

# Garante que existe backup antes de simular a falha.
$backup = Join-Path $backupDir $JarName
if (!(Test-Path $backup)) { Copy-Item $jar $backup }
$quarantine = Join-Path $prodDir ($JarName + ".quarentena")
Move-Item $jar $quarantine -Force
Write-Host "Falha simulada: o artefato foi movido temporariamente para $quarantine"
Write-Host "Agora execute um comando que tente usar o caminho original e capture o erro."
Read-Host "Após registrar a evidência da falha, pressione ENTER para restaurar"
Copy-Item $backup $jar -Force
$hashBackup = (Get-FileHash $backup -Algorithm SHA256).Hash
$hashRestored = (Get-FileHash $jar -Algorithm SHA256).Hash
Write-Host "Hash backup:     $hashBackup"
Write-Host "Hash restaurado: $hashRestored"
if ($hashBackup -ne $hashRestored) { throw "Hash divergente após restauração!" }
Remove-Item $quarantine -Force -ErrorAction SilentlyContinue
Write-Host "Artefato restaurado. Inicie o back-end e repita o teste funcional manualmente."
