$ErrorActionPreference = "Stop"
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$source = Join-Path $root "origem"
if (!(Test-Path (Join-Path $source "pom.xml"))) {
    throw "pom.xml não encontrado em origem. Confirme a ferramenta de build do projeto antes de continuar."
}
Push-Location $source
try {
    if (Test-Path ".\mvnw.cmd") { .\mvnw.cmd clean package }
    else { mvn clean package }
    if ($LASTEXITCODE -ne 0) { throw "Build Maven falhou. Corrija o erro antes de prosseguir." }
    $jars = Get-ChildItem ".\target\*.jar" -File
    if (!$jars) { throw "Build terminou, mas nenhum JAR foi encontrado em target." }
    $jars | Select-Object Name, Length, LastWriteTime | Format-Table
    $artifactDir = Join-Path $root "artefatos"
    foreach ($jar in $jars) { Copy-Item $jar.FullName $artifactDir -Force }
    Get-ChildItem $artifactDir -Filter "*.jar" | ForEach-Object {
        Get-FileHash $_.FullName -Algorithm SHA256
    }
    Write-Host "Artefatos copiados. Confira o README/pom.xml para saber como iniciar o JAR."
} finally { Pop-Location }
