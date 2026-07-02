$ErrorActionPreference = 'Stop'
$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$LocalMaven = Join-Path $ProjectRoot '.tools\apache-maven\bin\mvn.cmd'
$Maven = if (Test-Path $LocalMaven) { $LocalMaven } else { 'mvn' }

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

function Test-DatabaseSchema {
    $Mysql = Find-MysqlClient
    if (-not $Mysql) {
        Write-Warning 'Khong tim thay mysql.exe de kiem tra schema truoc khi chay.'
        return
    }

    $oldPwd = $env:MYSQL_PWD
    try {
        $env:MYSQL_PWD = $env:PETCARE_DB_PASSWORD
        $columns = & $Mysql --protocol=TCP -h localhost -u $env:PETCARE_DB_USER --batch --skip-column-names -e "SELECT column_name FROM information_schema.columns WHERE table_schema = 'petcare_db' AND table_name = 'invoices';" 2>$null
        if ($LASTEXITCODE -ne 0) {
            throw 'Khong ket noi duoc database. Hay chay .\setup.ps1 hoac kiem tra .env.ps1.'
        }

        $required = @('appointment_id', 'manual_customer_name', 'manual_pet_name', 'manual_service_name')
        foreach ($column in $required) {
            if ($columns -notcontains $column) {
                throw "Database dang thieu cot '$column' trong bang invoices. Hay chay .\migrate.ps1 bang tai khoan MySQL root."
            }
        }
    } finally {
        if ($null -ne $oldPwd) {
            $env:MYSQL_PWD = $oldPwd
        } else {
            Remove-Item Env:MYSQL_PWD -ErrorAction SilentlyContinue
        }
    }
}

if (Test-Path (Join-Path $ProjectRoot '.env.ps1')) {
    . (Join-Path $ProjectRoot '.env.ps1')
} else {
    throw 'Chua cau hinh database. Hay chay .\setup.ps1 truoc, sau do chay lai .\run.ps1.'
}

Set-Location $ProjectRoot
Test-DatabaseSchema
Start-Job -ScriptBlock {
    Start-Sleep -Seconds 5
    Start-Process 'http://localhost:8080/PetCareClinic/'
} | Out-Null
& $Maven package tomcat7:run-war
