#!/bin/bash
set -e
set -o pipefail

${LIQUIBASE_HOME}/liquibase \
	--classpath=${LIQUIBASE_HOME}/lib/${JDBC_JAR} \
	--changeLogFile=${LIQUIBASE_WORKSPACE}/capture/changeLog.yml \
	--driver=org.postgresql.Driver \
	--url=jdbc:postgresql://${AQTS_DATABASE_ADDRESS}:5432/${AQTS_DATABASE_NAME} \
	--username=${AQTS_SCHEMA_OWNER_USERNAME} \
	--password=${AQTS_SCHEMA_OWNER_PASSWORD} \
	--logLevel=info\
	--liquibaseCatalogName=${AQTS_SCHEMA_NAME} \
	--liquibaseSchemaName=${AQTS_SCHEMA_NAME} \
	update \
	-DAQTS_SCHEMA_OWNER_USERNAME=${AQTS_SCHEMA_OWNER_USERNAME} \
	-DAQTS_SCHEMA_OWNER_PASSWORD=${AQTS_SCHEMA_OWNER_PASSWORD} \
	-DAQTS_SCHEMA_NAME=${AQTS_SCHEMA_NAME}
