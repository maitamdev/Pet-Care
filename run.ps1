$ErrorActionPreference = 'Stop'
$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$LocalMaven = Join-Path $ProjectRoot '.tools\apache-maven\bin\mvn.cmd'
$Maven = if (Test-Path $LocalMaven) { $LocalMaven } else { 'mvn' }

if (Test-Path (Join-Path $ProjectRoot '.env.ps1')) {
    . (Join-Path $ProjectRoot '.env.ps1')
} else {
    Write-Warning 'Chua cau hinh database. Hay chay .\setup.ps1 truoc.'
}

Set-Location $ProjectRoot
Start-Job -ScriptBlock {
    Start-Sleep -Seconds 5
    Start-Process 'http://localhost:8080/PetCareClinic/'
} | Out-Null
& $Maven package tomcat7:run-war
