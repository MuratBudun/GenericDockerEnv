#!/bin/bash

option=$1
action=$2

declare -A composeFiles=(
    ["dbgate"]="docker-compose-dbgate.yml"
    ["mongo"]="docker-compose-mongo.yml"
    ["mysql"]="docker-compose-mysql.yml"
    ["mssql2022"]="docker-compose-mssql2022.yml"
    ["postgres"]="docker-compose-postgres.yml"
    ["rabbitmq"]="docker-compose-rabbitmq.yml"
)

declare -A envFiles=(
    ["dbgate"]="dbgate.env"
    ["mongo"]="mongo.env"
    ["mysql"]="mysql.env"
    ["mssql2022"]="mssql2022.env"
    ["postgres"]="postgres.env"
    ["rabbitmq"]="rabbitmq.env"
)

function ListOptions {
    echo "Useage: docker-compose.sh <option> <action>"
    echo "-------------------------------------------"
    echo "Available actions: up, down"
    echo "Available options for compose files:"
    echo "-------------------------------------------"
    for key in "${!composeFiles[@]}"; do 
        echo "$key  docker-compose.sh $key up | docker-compose.sh $key down"
    done
    echo ""
    echo -e "\e[33mUse 'all' to apply the action to all compose files.\e[0m"
}

function ExecuteAction {
    local composeFile=$1
    local envFile=$2
    local action=$3

    if [[ -z "$composeFile" || -z "$envFile" || -z "$action" ]]; then
        echo -e "\e[31mInvalid parameters.\e[0m"
        return
    fi
    if [[ ! -f "./compose/$composeFile" ]]; then
        echo -e "\e[31mCompose file not found. (./compose/$composeFile)\e[0m"
        return
    fi
    if [[ ! -f "./env/$envFile" ]]; then
        echo -e "\e[31mEnvironment file not found. (./env/$envFile)\e[0m"
        return
    fi
    if [[ "$action" != "up" && "$action" != "down" ]]; then
        echo -e "\e[31mInvalid action.\e[0m"
        return
    fi
    if [[ "$action" == "up" ]]; then
        docker-compose -f "./compose/$composeFile" --env-file "./env/_passwords.env" --env-file "./env/$envFile" $action -d
    else
        docker-compose -f "./compose/$composeFile" --env-file "./env/_passwords.env" --env-file "./env/$envFile" $action
    fi
}

function PrintTitle {
    echo ""
    echo -e "\e[36m==========================================\e[0m"
    echo -e "\e[36mGeneric Docker Environment for Development\e[0m"
    echo -e "\e[36m==========================================\e[0m"
}

PrintTitle

if [[ -z "$option" || -z "$action" ]]; then
    ListOptions
elif [[ "$option" == "all" ]]; then
    for key in "${!composeFiles[@]}"; do
        ExecuteAction "${composeFiles[$key]}" "${envFiles[$key]}" "$action"
    done
else
    if [[ -n "${composeFiles[$option]}" ]]; then
        ExecuteAction "${composeFiles[$option]}" "${envFiles[$option]}" "$action"
    else
        echo -e "\e[31mInvalid option.\e[0m"
        ListOptions
    fi
fi