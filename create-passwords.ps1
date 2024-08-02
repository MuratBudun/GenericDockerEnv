param (
    [string]$option = ""
)

function PrintTitle {
    Write-Host ""
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "Generic Docker Environment for Development" -ForegroundColor Cyan
    Write-Host "Create _passwords.env file in env folder  " -ForegroundColor Cyan
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "Usage: ./create-passwords.ps1 <option>"
    Write-Host "Options: o = overwrite"
    Write-Host "Example: ./create-passwords.ps1 o"
}

function CreateRandomPassword {
    param (
        [int]$length = 16
    )

    $upper = 1..($length / 4) | ForEach-Object { [char[]]([char]'A'..[char]'Z') | Get-Random }
    $lower = 1..($length / 4) | ForEach-Object { [char[]]([char]'a'..[char]'z') | Get-Random }
    $digit = 1..($length / 4) | ForEach-Object { [char[]]([char]'0'..[char]'9') | Get-Random }

    $special = '!'
    $specialCount = 1

    $passwordArray = $upper + $lower + $digit
    $passwordArray += 1..($length - $passwordArray.Length - $specialCount) | ForEach-Object { [char[]]([char]'A'..[char]'Z') + ([char]'a'..[char]'z') + ([char]'0'..[char]'9') | Get-Random }
    $passwordArray += $special

    $passwordArray = $passwordArray | Sort-Object { Get-Random }

    -join $passwordArray
}


function CreateEnvFile {
    param ($envFilePath)
    $passwords = @{
        "MSSQL_SA_PASSWORD" = CreateRandomPassword 10 
        "MONGO_ROOT_PASSWORD" = CreateRandomPassword 10
        "MYSQL_ROOT_PASSWORD" = CreateRandomPassword 10
        "POSTGRES_PASSWORD" = CreateRandomPassword 10
        "RABBITMQ_PASSWORD" = CreateRandomPassword 10
    }

    $passwords.GetEnumerator() | Sort-Object Key | ForEach-Object {
        $_.Key + "=" + $_.Value
    } | Out-File $envFilePath -Encoding utf8
    Write-Host ""
    Write-Host "File content:" -ForegroundColor Yellow
    Get-Content $envFilePath
}

PrintTitle;

$envFile = "_passwords.env"
$envFilePath = "./env/$envFile"

if (-not (Test-Path $envFilePath)) {
    Write-Host "Creating $envFile file in env folder." -ForegroundColor Yellow
    CreateEnvFile $envFilePath
} else {
    Write-Host "File already exists ($envFilePath)" -ForegroundColor Red
    if ($option -eq "o") {
        Write-Host "Overwriting file." -ForegroundColor Yellow
        Remove-Item $envFilePath
        CreateEnvFile $envFilePath
    }
    else {
        Write-Host "Use o option to overwrite." -ForegroundColor Cyan
    }
}