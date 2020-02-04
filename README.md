# Aquarius Timeseries Capture (AQTS) Database Setup

This repository contains Liquibase scripts for creating the Aquarious Timeseries database.

## Docker
Also included are Docker Compose scripts to:
* Create PostgreSQL and Liquibase containers for testing the scripts.
* Create a continuous integration PostgreSQL database container.

### Docker Network
A named Docker Network is required for local running of the containers. Creating this network facilitates other local container access to the database without having to maintain a massive Docker Compose 
script encompassing all of the required pieces. The name of this network is provided by the __LOCAL_NETWORK_NAME__ environment variable. The following is a sample command for creating your own local network. In this example the name is aqtsNet and the ip addresses will be 172.26.0.x

```
docker network create --subnet=172.26.0.0/16 aqtsNet
```

### Environment variables
In order to use the docker compose scripts, you will need to create a .env file in the project directory containing 
the following (shown are example values):

```
POSTGRES_PASSWORD=<changeMe>

AQTS_DATABASE_ADDRESS=<database_address>
AQTS_DATABASE_NAME=<database_name>
AQTS_DB_OWNER_USERNAME=<db_owner>
AQTS_DB_OWNER_PASSWORD=<changeMe>

AQTS_SCHEMA_NAME=<schema_name>
AQTS_SCHEMA_OWNER_USERNAME=<schema_owner>
AQTS_SCHEMA_OWNER_PASSWORD=<changeMe>

LOCAL_NETWORK_NAME=<aqts_capture>

DB_IPV4=<172.26.0.2>
DB_PORT=<5444>
DB_CI_IPV4=<172.25.0.4>
DB_CI_PORT=<5435>
LIQUIBASE_IPV4=<172.26.0.3>

LIQUIBASE_VERSION=<3.8.5>
JDBC_JAR=<postgresql-42.2.9.jar>

```

#### Environment variable definitions

* **POSTGRES_PASSWORD** - Password for the postgres user.

* **AQTS_DATABASE_ADDRESS** - Host name or IP address of the PostgreSQL database.
* **AQTS_DATABASE_NAME** - Name of the PostgreSQL database to create for containing the schema.
* **AQTS_DB_OWNER_USERNAME** - Role which will own the database.
* **AQTS_DB_OWNER_PASSWORD** - Password for the **AQTS_DB_OWNER_USERNAME** role.

* **AQTS_SCHEMA_NAME** - Name of the Schema which will contain the database objects.
* **AQTS_SCHEMA_OWNER_USERNAME** - Role which will own the schema and related objects.
* **AQTS_SCHEMA_OWNER_PASSWORD** - Password for the **AQTS_SCHEMA_OWNER_USERNAME** role.

* **LOCAL_NETWORK_NAME** - The name of the local Docker Network you have created for using these images/containers.

* **DB_IPV4** - The IP address in your Docker Network you would like assigned to the database container used for testing the Liquibase scripts.
* **DB_PORT** - The localhost port on which to expose the script testing database container.
* **DB_CI_IPV4** - The IP address in your Docker Network you would like assigned to the database container for the CI database.
* **DB_CI_PORT** - The localhost port on which to expose the CI database container.
* **LIQUIBASE_IPV4** - The IP address you would like assigned to the Liquibase runner container.

* **LIQUIBASE_VERSION** - The version of Liquibase to install.
* **JDBC_JAR** - The jdbc driver to install.

### Testing Liquibase scripts
The Liquibase scripts can be tested locally by spinning up the generic database (db) and the liquibase container.

```
% docker-compose up -d db
% docker-compose up liquibase
```

The local file system is mounted into the liquibase container. This allows you to change the liquibase and shell scripts and run the changes by just re-launching the liquibase container. Note that all standard Liquibase caveats apply.

The postgres database will be available on your localhost's port DB_PORT, allowing for visual inspection of the results.
