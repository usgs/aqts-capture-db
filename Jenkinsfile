pipeline {
  agent {
    node {
      label 'team:iow'
    }
  }
  stages {
    stage('Set Build Description') {
      steps {
        script {
          currentBuild.description = "Deploy to ${env.DEPLOY_STAGE}"
        }
      }
    }
    stage('Clean Workspace') {
      steps {
        cleanWs()
      }
    }
    stage('Git Clone') {
      steps {
        checkout([$class: 'GitSCM', branches: [[name: '*/master']],
        doGenerateSubmoduleConfigurations: false,
        userRemoteConfigs: [[credentialsId: 'CIDA-Jenkins-GitHub',
        url: 'https://github.com/usgs/aqts-capture-db.git']]])
      }
    }
    stage('Download liquibase jar') {
      steps {
        sh '''mkdir $WORKSPACE/rc
          /usr/local/bin/aws s3 cp s3://owi-common-resources/resources/InstallFiles/liquibase/liquibase-$LIQUIBASE_VERSION.tar.gz $WORKSPACE/rc/liquibase.tar.gz
          /usr/bin/tar xzf $WORKSPACE/rc/liquibase.tar.gz --overwrite -C $WORKSPACE/rc
          /usr/local/bin/aws s3 cp s3://owi-common-resources/resources/InstallFiles/postgres/$JDBC_JAR $WORKSPACE/rc/lib/$JDBC_JAR
        '''
      }
    }
    stage('Run liquibase') {
      steps {
        script {
          def secretsString = sh(script: '/usr/local/bin/aws ssm get-parameter --name "/aws/reference/secretsmanager/NWCAPTURE-DB-$DEPLOY_STAGE" --query "Parameter.Value" --with-decryption --output text --region "us-west-2"', returnStdout: true).trim()
          def secretsJson =  readJSON text: secretsString
          env.AQTS_DATABASE_ADDRESS = secretsJson.DATABASE_ADDRESS
          env.AQTS_DATABASE_NAME = secretsJson.DATABASE_NAME
          env.AQTS_DB_OWNER_USERNAME = secretsJson.DB_OWNER_USERNAME
          env.AQTS_DB_OWNER_PASSWORD = secretsJson.DB_OWNER_PASSWORD
          env.AQTS_SCHEMA_NAME = secretsJson.SCHEMA_NAME
          env.AQTS_SCHEMA_OWNER_USERNAME = secretsJson.SCHEMA_OWNER_USERNAME
          env.AQTS_SCHEMA_OWNER_PASSWORD = secretsJson.SCHEMA_OWNER_PASSWORD

          sh '''
            export POSTGRES_PASSWORD=$(/usr/local/bin/aws ssm get-parameter --name "/NWCAPPG_SU_PW" --query "Parameter.Value"  --with-decryption --output text --region "us-west-2")

            export LIQUIBASE_HOME=$WORKSPACE/rc
            export LIQUIBASE_WORKSPACE=$WORKSPACE/liquibase/changeLogs

            chmod +x $WORKSPACE/liquibase/scripts/dbInit/z1_postgres_liquibase.sh
            chmod +x $WORKSPACE/liquibase/scripts/dbInit/z2_rc_liquibase.sh
            $WORKSPACE/liquibase/scripts/dbInit/z1_postgres_liquibase.sh
            $WORKSPACE/liquibase/scripts/dbInit/z2_rc_liquibase.sh
          '''
        }
      }
    }
  }
}
