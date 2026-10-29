param(
    [Parameter(Mandatory=$true)][string]$JarName
)
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
foreach ($envName in @("homolog","prod")) {
    $path = Join-Path (Join-Path $root $envName) $JarName
    if (!(Test-Path $path)) { Write-Host "$envName: arquivo ausente"; continue }
    $hash = (Get-FileHash $path -Algorithm SHA256).Hash
    Write-Host "$envName : $hash"
}
