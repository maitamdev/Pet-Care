$ErrorActionPreference = 'Stop'
$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$Mysql = 'C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe'

if (-not (Test-Path $Mysql)) {
    throw 'Khong tim thay MySQL 8.0. Hay cai MySQL Server truoc.'
}

$securePassword = Read-Host 'Nhap mat khau MySQL root' -AsSecureString
$password = [System.Net.NetworkCredential]::new('', $securePassword).Password
$appPassword = ([guid]::NewGuid().ToString('N') + [guid]::NewGuid().ToString('N'))
$env:MYSQL_PWD = $password
try {
    & $Mysql -uroot --default-character-set=utf8mb4 -e "source $($ProjectRoot.Replace('\','/'))/database/petcare_db.sql"
    if ($LASTEXITCODE -ne 0) { throw 'Khong the khoi tao database.' }
    & $Mysql -uroot -e "CREATE USER IF NOT EXISTS 'petcare_app'@'localhost' IDENTIFIED BY '$appPassword'; ALTER USER 'petcare_app'@'localhost' IDENTIFIED BY '$appPassword'; GRANT SELECT, INSERT, UPDATE, DELETE ON petcare_db.* TO 'petcare_app'@'localhost'; FLUSH PRIVILEGES;"
    if ($LASTEXITCODE -ne 0) { throw 'Khong the tao tai khoan database cho ung dung.' }
} finally {
    Remove-Item Env:MYSQL_PWD -ErrorAction SilentlyContinue
}

Set-Content -Path (Join-Path $ProjectRoot '.env.ps1') -Encoding UTF8 -Value "`$env:PETCARE_DB_USER='petcare_app'`n`$env:PETCARE_DB_PASSWORD='$appPassword'"
Write-Host 'Da khoi tao database. Chay .\run.ps1 de mo ung dung.' -ForegroundColor Green
