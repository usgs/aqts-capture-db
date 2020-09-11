#!/bin/bash
set -e
set -o pipefail

# postgres to postgres db scripts
${LIQUIBASE_HOME}/liquibase \
	--classpath=${LIQUIBASE_HOME}/lib/${JDBC_JAR} \
	--changeLogFile=${LIQUIBASE_WORKSPACE}/postgres/postgres/changeLog.yml \
	--driver=org.postgresql.Driver \
	--url=jdbc:postgresql://${AQTS_DATABASE_ADDRESS}:5432/postgres \
	--username=postgres \
	--password=${POSTGRES_PASSWORD} \
	--logLevel=info\
	--liquibaseCatalogName=public \
	--liquibaseSchemaName=public \
	update \
	-DAQTS_DATABASE_NAME=${AQTS_DATABASE_NAME} \
	-DAQTS_DB_OWNER_USERNAME=${AQTS_DB_OWNER_USERNAME} \
	-DAQTS_DB_OWNER_PASSWORD=${AQTS_DB_OWNER_PASSWORD} \
	-DAQTS_SCHEMA_OWNER_USERNAME=${AQTS_SCHEMA_OWNER_USERNAME} \
	-DAQTS_SCHEMA_OWNER_PASSWORD=${AQTS_SCHEMA_OWNER_PASSWORD}

# postgres to capture db scripts
${LIQUIBASE_HOME}/liquibase \
	--classpath=${LIQUIBASE_HOME}/lib/${JDBC_JAR} \
	--changeLogFile=${LIQUIBASE_WORKSPACE}/postgres/capture/changeLog.yml \
	--driver=org.postgresql.Driver \
	--url=jdbc:postgresql://${AQTS_DATABASE_ADDRESS}:5432/${AQTS_DATABASE_NAME} \
	--username=postgres \
	--password=${POSTGRES_PASSWORD} \
	--logLevel=info\
	--liquibaseCatalogName=public \
	--liquibaseSchemaName=public \
	update \
	-DAQTS_SCHEMA_OWNER_USERNAME=${AQTS_SCHEMA_OWNER_USERNAME} \
	-DAQTS_SCHEMA_NAME=${AQTS_SCHEMA_NAME}

sudo -u postgres psql ${AQTS_DATABASE_NAME} -c "create extension if not exists aws_s3 cascade"
