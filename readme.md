# Generic Docker Environments for Developers

# Container List
- MongoDb | https://www.mongodb.com
- MongoExpress | https://github.com/mongo-express/mongo-express
- Microsoft SQL Server 2022 Developer Edition | https://www.microsoft.com/en/sql-server/sql-server-2022
- MySQL | MariaDb 10.6 | https://mariadb.org/
- phpMyAdmin | https://www.phpmyadmin.net/
- PostgreSQL | https://www.postgresql.org/
- pgAdmin | https://www.pgadmin.org/
- DbGate | https://dbgate.org/

![image](https://github.com/user-attachments/assets/14220195-5161-4159-82de-cde430dff623)

# Prerequisites
* [Docker](https://www.docker.com)
* Windows
  * [Set up Linux Containers on Windows 10](https://learn.microsoft.com/en-us/virtualization/windowscontainers/quick-start/quick-start-windows-10-linux)
  * [PowerShell](https://learn.microsoft.com/en-us/powershell/)

Windows Useful Links
* [Set-ExecutionPolicy](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7.4)


# Getting Started
### Clone
```bash
git clone https://github.com/MuratBudun/GenericDockerEnv.git
cd GenericDockerEnv
```

### chmod +x for Linux / maxOS
```bash
chmod +x create-passwords.sh
chmod +x docker-compose.sh
```

### Create Docker Network
```bash
docker network create gen_dev_net
```

### Create Passwords
Password file path: **./env/_passwords.env**
* Windows
  ```
  ./create-passwords.ps1
  ```
* Linux / macOS
  ```bash
  ./create-passwords.sh
  ```

## How To Use
### Windows PowerShell
#### Useage:
* Options and Actions
  ```
  Actions: up | down
  Options: all | dbgate | mongo | mysql |  mssql2022 | postgres
  ```
* Windows
  ```
  .\docker-compose.ps1 <Option> <Action>
  ```
* Linux / macOS
  ```bash
  .\docker-compose.sh <Option> <Action>
  ```

#### Examples:
* Windows
  ```
  .\docker-compose.ps1 all up        
  .\docker-compose.ps1 all down
  .\docker-compose.ps1 dbgate up
  ```
* Linux / macOS
  ```
  .\docker-compose.sh all up        
  .\docker-compose.sh all down
  .\docker-compose.sh dbgate up
  ```
* Docker CLI
  ```
  docker compose -f ./compose/docker-compose-dbgate.yml --env-file ./env/_passwords.env --env-file ./env/dbgate.env up -d
  ```

## DbGate
http://localhost:8082

![image](https://github.com/user-attachments/assets/fc20d137-0e3a-435f-8c02-f6455ca266c2)


## Microsoft SQL Server 2022 Developer Edition
![image](https://github.com/user-attachments/assets/4fc3985e-3f69-4090-9b81-3a5286a632ed)

### Connection
* Server: **localhost**
* Port: **1466**
* Internal Port: **1433**
* User: **sa**
* Password: **{MSSQL_SA_PASSWORD}**
### Example Connection String
```
Data Source=localhost,1466;Initial Catalog=master;User ID=sa;Password={MSSQL_SA_PASSWORD};
```
**Note:** 
The **MSSQL_SA_PASSWORD** variable is the contents of ./env/_passwords.env cards. If you cannot find the ./env/_passwords.env file, repeat the password creation step.


## MongoDb and Mongo Express
### Connection
* Server: **localhost**
* Port: **27170**
* Internal Port: **27017**
* User: **root**
* Password: **{MONGO_ROOT_PASSWORD}**
### Example Connection String
```
mongodb://root:{MONGO_ROOT_PASSWORD}@localhost:27170
```
**Note:** 
The **MONGO_ROOT_PASSWORD** variable is the contents of ./env/_passwords.env cards. If you cannot find the ./env/_passwords.env file, repeat the password creation step.

### Mongo Express
* http://localhost:8081
* user: **admin**
* password: **{MONGO_ROOT_PASSWORD}**


## MySQL and phpMyAdmin
### Connection
* Server: **localhost**
* Port: **6603**
* Internal Port: **3306**
* User: **root**
* Password: **{MYSQL_ROOT_PASSWORD}**

**Note:** 
The **MYSQL_ROOT_PASSWORD** variable is the contents of ./env/_passwords.env cards. If you cannot find the ./env/_passwords.env file, repeat the password creation step.

### phpMyAdmin
http://localhost:8084


## PostgreSQL
### Connection
* Server: **localhost**
* Port: **5234**
* Internal Port: **5432**
* User: **postgres**
* Password: **{POSTGRES_PASSWORD}**

**Note:** 
The **POSTGRES_PASSWORD** variable is the contents of ./env/_passwords.env cards. If you cannot find the ./env/_passwords.env file, repeat the password creation step.

### pgAdmin
* http://localhost:8083
* email: **pgadmin@gen-env.com**
* password: **{POSTGRES_PASSWORD}**