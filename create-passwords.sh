#!/bin/bash

option=$1

CYAN="\033[36m"
RED="\033[31m"
YELLOW="\033[33m"
RESET="\033[0m"

print_title() {
    echo ""
    echo -e "${CYAN}==========================================${RESET}"
    echo -e "${CYAN}Generic Docker Environment for Development${RESET}"
    echo -e "${CYAN}Create _passwords.env file in env folder  ${RESET}"
    echo -e "${CYAN}==========================================${RESET}"
    echo "Usage: ./create-passwords.sh <option>"
    echo "Options: o = overwrite"
    echo "Example: ./create-passwords.sh o"
}

create_random_password() {
    local length=$1
    local upper=$(LC_CTYPE=C tr -dc 'A-Z' < /dev/urandom | head -c $((length / 4)))
    local lower=$(LC_CTYPE=C tr -dc 'a-z' < /dev/urandom | head -c $((length / 4)))
    local digit=$(LC_CTYPE=C tr -dc '0-9' < /dev/urandom | head -c $((length / 4)))
    
    local special="!"
    local specialCount=1
    
    local remainder=$((length - (${#upper} + ${#lower} + ${#digit} + $specialCount)))
    local all=$(LC_CTYPE=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c $remainder)
    
    local password="${upper}${lower}${digit}${all}${special}"
    
    echo $(echo "$password" | fold -w1 | awk 'BEGIN {srand()} {print rand(), $0}' | sort -n | cut -d ' ' -f2 | LC_CTYPE=C tr -d '\n')
}

create_env_file() {
    local env_file_path=$1
    local passwords=(
        "MSSQL_SA_PASSWORD=$(create_random_password 10)"
        "MONGO_ROOT_PASSWORD=$(create_random_password 10)"
        "MYSQL_ROOT_PASSWORD=$(create_random_password 10)"
        "POSTGRES_PASSWORD=$(create_random_password 10)"
        "RABBITMQ_PASSWORD=$(create_random_password 10)"
    )

    printf "%s\n" "${passwords[@]}" > "$env_file_path"
    echo ""
    echo -e "${YELLOW}File content:${RESET}"
    cat "$env_file_path"
}

print_title

env_file="_passwords.env"
env_file_path="./env/$env_file"

if [ ! -f "$env_file_path" ]; then
    echo -e "${YELLOW}Creating $env_file file in env folder.${RESET}"
    create_env_file "$env_file_path"
else
    echo -e "${RED}File already exists ($env_file_path)${RESET}"
    if [ "$option" == "o" ]; then
        echo -e "${YELLOW}Overwriting file.${RESET}"
        rm "$env_file_path"
        create_env_file "$env_file_path"
    else
        echo -e "${CYAN}Use o option to overwrite.${RESET}"
    fi
fi
