$ErrorActionPreference = 'Stop'
$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$Maven = Join-Path $ProjectRoot '.tools\apache-maven\bin\mvn.cmd'

if (-not (Test-Path $Maven)) {
    throw 'Chua co Maven cuc bo. Hay cai Maven hoac khoi phuc thu muc .tools/apache-maven.'
}
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
& $Maven tomcat7:run
