#! /bin/sh

#JAVA_HOME=/usr/java/jdk1.7.0_91
JAVA_HOME=/usr/java/jdk1.7.0_75

DATA_MIGRATION_HOME=/app/bea/EOC/GRAN-551/dataMigration
DATA_MIGRATION_CONFIG=$DATA_MIGRATION_HOME/config
DATA_MIGRATION_LIB=$DATA_MIGRATION_HOME/lib
DATA_MIGRATION_LOG4J=$DATA_MIGRATION_LIB/log4j/commons-logging-1.2.jar:$DATA_MIGRATION_LIB/log4j/log4j.jar
DATA_MIGRATION_WL=$DATA_MIGRATION_LIB/wl/wlfullclient-12.1.2.jar
DATA_MIGRATION_ORACLE=$DATA_MIGRATION_LIB/oracle/ojdbc6.jar:$DATA_MIGRATION_LIB/oracle/orai18n.jar:$DATA_MIGRATION_LIB/oracle/orai18n-mapping.jar

DATA_MIGRATION_ASI=$DATA_MIGRATION_LIB/asi/asi-16.0.0.1_BCM.jar:$DATA_MIGRATION_LIB/asi/core-platform-ejb-16.0.0.1_BCM.jar:$DATA_MIGRATION_LIB/asi/core-platform-lib-16.0.0.1_BCM.jar:$DATA_MIGRATION_LIB/asi/core-platform-utility-16.0.0.1_BCM.jar:$DATA_MIGRATION_LIB/asi/core-services-client-stubs-16.0.0.1_BCM.jar:$DATA_MIGRATION_LIB/asi/ipex-services-client-stubs-16.0.0.1_BCM.jar:$DATA_MIGRATION_LIB/asi/obj-sync-services-client-stubs-16.0.0.1_BCM.jar:$DATA_MIGRATION_LIB/asi/rm-services-client-stubs-16.0.0.1_BCM.jar:$DATA_MIGRATION_LIB/asi/worx-services-client-stubs-16.0.0.1_BCM.jar

DATA_MIGRATION_CLASSPATH=$DATA_MIGRATION_HOME:$DATA_MIGRATION_HOME/dataMigration.jar:$DATA_MIGRATION_LOG4J:$DATA_MIGRATION_WL:$DATA_MIGRATION_ORACLE:$DATA_MIGRATION_ASI:$DATA_MIGRATION_CONFIG

echo "$JAVA_HOME/bin/java" -classpath "$DATA_MIGRATION_CLASSPATH" com.ericsson.stc.dataMigration.CustomerMigrationTool
"$JAVA_HOME/bin/java" -classpath "$DATA_MIGRATION_CLASSPATH" com.ericsson.stc.dataMigration.CustomerMigrationTool

