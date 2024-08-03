#!/bin/bash

option=$1
action=$2

CYAN="\033[36m"
RED="\033[31m"
YELLOW="\033[33m"
RESET="\033[0m"

keys=("dbgate" "mongo" "mysql" "mssql2022" "postgres" "rabbitmq")
composeFiles=("docker-compose-dbgate.yml" "docker-compose-mongo.yml" "docker-compose-mysql.yml" "docker-compose-mssql2022.yml" "docker-compose-postgres.yml" "docker-compose-rabbitmq.yml")
envFiles=("dbgate.env" "mongo.env" "mysql.env" "mssql2022.env" "postgres.env" "rabbitmq.env")

function ListOptions {
    echo "Useage: docker-compose.sh <option> <action>"
    echo "-------------------------------------------"
    echo "Available actions: up, down"
    echo "Available options for compose files:"
    echo "-------------------------------------------"
    for i in "${!keys[@]}"; do
        key="${keys[$i]}"
        echo "$key  docker-compose.sh $key up | docker-compose.sh $key down"
    done
    echo ""
    echo -e "${CYAN}Use 'all' to apply the action to all compose files.${RESET}"
}

function GetFilesForKey {
    local key=$1
    local composeFile=""
    local envFile=""
    local found=0

    for i in "${!keys[@]}"; do
        if [[ "${keys[$i]}" == "$key" ]]; then
            composeFile="${composeFiles[$i]}"
            envFile="${envFiles[$i]}"
            found=1
            break
        fi
    done

    if [[ $found -eq 0 ]]; then
        echo "Key '$key' not found."
        return 1
    else
        echo "$composeFile"
        echo "$envFile"
        return 0
    fi
}

function ExecuteAction {
    local composeFile=$1
    local envFile=$2
    local action=$3

    if [[ -z "$composeFile" || -z "$envFile" || -z "$action" ]]; then
        echo -e "${RED}Invalid parameters.${RESET}"
        return
    fi
    if [[ ! -f "./compose/$composeFile" ]]; then
        echo -e "${RED}Compose file not found. (./compose/$composeFile)${RESET}"
        return
    fi
    if [[ ! -f "./env/$envFile" ]]; then
        echo -e "${RED}Environment file not found. (./env/$envFile)${RESET}"
        return
    fi
    if [[ "$action" != "up" && "$action" != "down" ]]; then
        echo -e "${RED}Invalid action.${RESET}"
        return
    fi

    if [[ "$action" == "up" ]]; then
        docker compose -f "./compose/$composeFile" --env-file "./env/$envFile" --env-file "./env/_passwords.env" $action -d
    else
        docker compose -f "./compose/$composeFile" --env-file "./env/$envFile" --env-file "./env/_passwords.env" $action 
    fi
}

function PrintTitle {
    echo ""
    echo -e "${CYAN}==========================================${RESET}"
    echo -e "${CYAN}Generic Docker Environment for Development${RESET}"
    echo -e "${CYAN}==========================================${RESET}"
}

PrintTitle

if [[ -z "$option" || -z "$action" ]]; then
    ListOptions
elif [[ "$option" == "all" ]]; then
    for i in "${!keys[@]}"; do
        key="${keys[$i]}"
        ExecuteAction "${composeFiles[$key]}" "${envFiles[$key]}" "$action"
    done
else
    files=$(GetFilesForKey "$option")
    if [[ $? -eq 0 ]]; then
        composeFile=$(echo "$files" | head -n 1)
        envFile=$(echo "$files" | tail -n 1)
        ExecuteAction "${composeFile}" "${envFile}" "$action"
    else
        echo -e "${RED}Invalid option.${RESET}"
        ListOptions
    fi
fi