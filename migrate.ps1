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

try {
    if ($password) {
        $env:MYSQL_PWD = $password
    }

    & $Mysql -uroot --default-character-set=utf8mb4 -e "source $($ProjectRoot.Replace('\','/'))/database/invoices.sql"
    if ($LASTEXITCODE -ne 0) {
        throw 'Khong the cap nhat bang hoa don.'
    }
} finally {
    Remove-Item Env:MYSQL_PWD -ErrorAction SilentlyContinue
}

Write-Host 'Da cap nhat schema database thanh cong. Chay .\run.ps1 de mo ung dung.' -ForegroundColor Green
