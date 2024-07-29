param (
    [string]$option,
    [string]$action
)

$composeFiles = @{
    "dbgate" = "docker-compose-dbgate.yml";
    "mongo" = "docker-compose-mongo.yml";
    "mysql" = "docker-compose-mysql.yml";
    "mssql2022"= "docker-compose-mssql2022.yml";
    "postgres" = "docker-compose-postgres.yml";
}

$envFiles = @{
    "dbgate" = "dbgate.env";
    "mongo" = "mongo.env";
    "mysql" = "mysql.env";
    "mssql2022" = "mssql2022.env";
    "postgres" = "postgres.env";
}

function ListOptions {
    Write-Host "Useage: docker-compose.ps1 <option> <action>"
    Write-Host "-------------------------------------------"
    Write-Host "Available actions: up, down"
    Write-Host "Available options for compose files:"
    Write-Host "-------------------------------------------"
    $composeFiles.Keys | ForEach-Object { 
        Write-Host $_ " docker-compose.ps1 $_ up | docker-compose.ps1 $_ down" 
    }
    Write-Host ""
    Write-Host "Use 'all' to apply the action to all compose files." -ForegroundColor Yellow
}

function ExecuteAction {
    param ($composeFile, $envFile, $action)

    if (-not $composeFile -or -not $envFile -or -not $action) {
        Write-Host "Invalid parameters." -ForegroundColor Red
        return
    }
    if (-not (Test-Path "./compose/$composeFile")) {
        Write-Host "Compose file not found. (./compose/$composeFile)" -ForegroundColor Red
        return
    }
    if (-not (Test-Path "./env/$envFile")) {
        Write-Host "Environment file not found. (./env/$envFile)" -ForegroundColor Red
        return
    }
    if ($action -ne "up" -and $action -ne "down") {
        Write-Host "Invalid action." -ForegroundColor Red
        return
    }
    if ($action -eq "up") {
        docker-compose -f ./compose/$composeFile --env-file ./env/_passwords.env --env-file ./env/$envFile $action -d
    } else {
        docker-compose -f ./compose/$composeFile --env-file ./env/_passwords.env --env-file ./env/$envFile $action
    }
}
function PrintTitle {
    Write-Host ""
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "Generic Docker Environment for Development" -ForegroundColor Cyan
    Write-Host "==========================================" -ForegroundColor Cyan
}

PrintTitle;

if (-not $option -or -not $action) {
    ListOptions
} elseif ($option -eq "all") {
    foreach ($key in $composeFiles.Keys) {
        ExecuteAction $composeFiles[$key] $envFiles[$key] $action
    }
} else {
    if ($composeFiles.ContainsKey($option)) {
        ExecuteAction $composeFiles[$option] $envFiles[$option] $action
    } else {
        Write-Host "Invalid option." -ForegroundColor Red
        ListOptions
    }
}
