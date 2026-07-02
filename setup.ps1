$ErrorActionPreference = 'Stop'
$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

function Find-MysqlClient {
    $fromPath = Get-Command mysql.exe -ErrorAction SilentlyContinue
    if ($fromPath) {
        return $fromPath.Source
    }

    $candidates = @(
        'C:\mysql\bin\mysql.exe',
        'C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe',
        'C:\Program Files\MySQL\MySQL Server 9.0\bin\mysql.exe',
        'C:\Program Files\MySQL\MySQL Workbench 8.0 CE\mysql.exe',
        'C:\xampp\mysql\bin\mysql.exe',
        'C:\laragon\bin\mysql\mysql-8.0\bin\mysql.exe',
        'D:\xampp\mysql\bin\mysql.exe',
        'D:\laragon\bin\mysql\mysql-8.0\bin\mysql.exe'
    )

    foreach ($candidate in $candidates) {
        if (Test-Path $candidate) {
            return $candidate
        }
    }

    return $null
}

$Mysql = Find-MysqlClient
if (-not $Mysql) {
    throw 'Khong tim thay mysql.exe. Hay cai MySQL Server/XAMPP/Laragon hoac them mysql.exe vao PATH.'
}

Write-Host "Dung MySQL client: $Mysql" -ForegroundColor Cyan
$securePassword = Read-Host 'Nhap mat khau MySQL root' -AsSecureString
$password = [System.Net.NetworkCredential]::new('', $securePassword).Password
$appPassword = ([guid]::NewGuid().ToString('N') + [guid]::NewGuid().ToString('N'))

if ($password) {
    $env:MYSQL_PWD = $password
    & $Mysql -uroot --connect-timeout=3 -e "SELECT 1" *> $null
    if ($LASTEXITCODE -ne 0) {
        Remove-Item Env:MYSQL_PWD -ErrorAction SilentlyContinue
        & $Mysql -uroot --connect-timeout=3 -e "SELECT 1" *> $null
        if ($LASTEXITCODE -eq 0) {
            Write-Warning 'Mat khau root vua nhap khong dung. MySQL root tren may nay dang cho phep dang nhap khong can mat khau, setup se dung che do do.'
        } else {
            throw 'Sai mat khau MySQL root. Hay nhap lai dung mat khau hoac reset root password.'
        }
    }
}

try {
    & $Mysql -uroot --default-character-set=utf8mb4 -e "source $($ProjectRoot.Replace('\','/'))/database/petcare_db.sql"
    if ($LASTEXITCODE -ne 0) { throw 'Khong the khoi tao database.' }
    & $Mysql -uroot --default-character-set=utf8mb4 -e "source $($ProjectRoot.Replace('\','/'))/database/invoices.sql"
    if ($LASTEXITCODE -ne 0) { throw 'Khong the cap nhat bang hoa don.' }
    & $Mysql -uroot -e "CREATE USER IF NOT EXISTS 'petcare_app'@'localhost' IDENTIFIED BY '$appPassword'; ALTER USER 'petcare_app'@'localhost' IDENTIFIED BY '$appPassword'; GRANT SELECT, INSERT, UPDATE, DELETE ON petcare_db.* TO 'petcare_app'@'localhost'; FLUSH PRIVILEGES;"
    if ($LASTEXITCODE -ne 0) { throw 'Khong the tao tai khoan database cho ung dung.' }
} finally {
    Remove-Item Env:MYSQL_PWD -ErrorAction SilentlyContinue
}

Set-Content -Path (Join-Path $ProjectRoot '.env.ps1') -Encoding UTF8 -Value "`$env:PETCARE_DB_USER='petcare_app'`n`$env:PETCARE_DB_PASSWORD='$appPassword'"
Write-Host 'Da khoi tao database. Chay .\run.ps1 de mo ung dung.' -ForegroundColor Green
