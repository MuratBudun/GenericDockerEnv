# Generic Docker Envoriment for Development

## Container List
- MongoDb | https://www.mongodb.com
- MongoExpress | https://github.com/mongo-express/mongo-express
- Microsoft SQL Server 2022 Developer Edition | https://www.microsoft.com/en/sql-server/sql-server-2022
- MySQL | MariaDb 10.6 | https://mariadb.org/
- phpMyAdmin | https://www.phpmyadmin.net/
- PostgreSQL | https://www.postgresql.org/
- pgAdmin | https://www.pgadmin.org/
- DbGate | https://dbgate.org/


## Installation
### Create Docker Network
```bash
docker network create gen_dev_net
```

## How To Use
### Windows PowerShell
#### Useage:
```powershell
.\docker-compose.ps1 <Option> <Action>

Actions: up | down
Options: all
        dbgate
        mongo
        mysql
        mssql2022
        postgres
```
#### Examples:
```powershell
.\docker-compose.ps1 all up        
.\docker-compose.ps1 all down
.\docker-compose.ps1 dbgate up

Direct Command Example:
docker compose -f ./compose/docker-compose-dbgate.yml --env-file ./compose/_passwords.env --env-file ./compose/dbgate.env up -d
```
#### Docker Compose Command Usage:
```powershell
docker compose -f ./compose/docker-compose-dbgate.yml --env-file ./compose/_passwords.env --env-file ./compose/dbgate.env up -d
```
## DbGate
http://localhost:8082/

## MongoDb and Mongo Express
### Connection
* Server: **localhost**
* Port: **27170**
* Internal Port: **27017**
* User: **root**
* Password: **qJFC0yfJFEczxJR18xrc**
### Example Connection String
```
mongodb://root:qJFC0yfJFEczxJR18xrc@localhost:27170
```
**Note:** You can chnage this password on *./env/_passwords.env* file.
```
MONGO_ROOT_USER=root
MONGO_ROOT_PASSWORD=qJFC0yfJFEczxJR18xrc
```
### Mongo Express
* http://localhost:8081
* user: **admin**
* password: **pass**


## MySQL and phpMyAdmin
### Connection
* Server: **localhost**
* Port: **6603**
* Internal Port: **3306**
* User: **root**
* Password: **saNZ3VsFoDUTzwN05BG8**

**Note:** You can chnage this password on *./env/_passwords.env* file.
```
MYSQL_ROOT_PASSWORD=saNZ3VsFoDUTzwN05BG8
```

### phpMyAdmin
http://localhost:8084


## PostgreSQL
### Connection
* Server: **localhost**
* Port: **5234**
* Internal Port: **5432**
* User: **postgres**
* Password: **RaxQR54HY5i1bmjL9ppK**

**Note:** You can chnage this password on *./env/_passwords.env* file.
```
POSTGRES_USER=postgres
POSTGRES_PASSWORD=RaxQR54HY5i1bmjL9ppK
```

### pgAdmin
* http://localhost:8083
* email: **pgadmin@gen-env.com**
* password: **RaxQR54HY5i1bmjL9ppK**



