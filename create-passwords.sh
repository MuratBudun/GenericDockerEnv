#!/bin/bash

option=$1

print_title() {
    echo ""
    echo -e "\e[36m==========================================\e[0m"
    echo -e "\e[36mGeneric Docker Environment for Development\e[0m"
    echo -e "\e[36mCreate _passwords.env file in env folder  \e[0m"
    echo -e "\e[36m==========================================\e[0m"
    echo "Usage: ./create-passwords.sh <option>"
    echo "Options: o = overwrite"
    echo "Example: ./create-passwords.sh o"
}

create_random_password() {
    local length=$1
    local upper=$(tr -dc 'A-Z' < /dev/urandom | head -c $((length / 4)))
    local lower=$(tr -dc 'a-z' < /dev/urandom | head -c $((length / 4)))
    local digit=$(tr -dc '0-9' < /dev/urandom | head -c $((length / 4)))
    
    local special="!"
    local specialCount=1
    
    local remainder=$((length - (${#upper} + ${#lower} + ${#digit} + $specialCount)))
    local all=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c $remainder)
    
    local password="${upper}${lower}${digit}${all}${special}"
    
    echo $(echo "$password" | fold -w1 | shuf | tr -d '\n')
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
    echo -e "\e[33mFile content:\e[0m"
    cat "$env_file_path"
}

print_title

env_file="_passwords.env"
env_file_path="./env/$env_file"

if [ ! -f "$env_file_path" ]; then
    echo -e "\e[33mCreating $env_file file in env folder.\e[0m"
    create_env_file "$env_file_path"
else
    echo -e "\e[31mFile already exists ($env_file_path)\e[0m"
    if [ "$option" == "o" ]; then
        echo -e "\e[33mOverwriting file.\e[0m"
        rm "$env_file_path"
        create_env_file "$env_file_path"
    else
        echo -e "\e[36mUse o option to overwrite.\e[0m"
    fi
fi
