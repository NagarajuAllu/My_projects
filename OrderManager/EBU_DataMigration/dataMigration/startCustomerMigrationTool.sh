#! /bin/sh

JAVA_HOME=/usr/java/jdk1.7.0_91

CUSTOMER_MIGRATION_HOME=/app/bea/EOC/EBU_DataMigration/dataMigration
CUSTOMER_MIGRATION_CONFIG=$CUSTOMER_MIGRATION_HOME/config
CUSTOMER_MIGRATION_LIB=$CUSTOMER_MIGRATION_HOME/lib
CUSTOMER_MIGRATION_LOG4J=$CUSTOMER_MIGRATION_LIB/log4j/commons-logging-1.2.jar:$CUSTOMER_MIGRATION_LIB/log4j/log4j.jar
CUSTOMER_MIGRATION_WL=$CUSTOMER_MIGRATION_LIB/wl/wlfullclient-12.1.2.jar
CUSTOMER_MIGRATION_ORACLE=$CUSTOMER_MIGRATION_LIB/oracle/ojdbc6.jar:$CUSTOMER_MIGRATION_LIB/oracle/orai18n.jar:$CUSTOMER_MIGRATION_LIB/oracle/orai18n-mapping.jar

CUSTOMER_MIGRATION_ASI=$CUSTOMER_MIGRATION_LIB/asi/asi-16.0.0.1_BCM.jar:$CUSTOMER_MIGRATION_LIB/asi/core-platform-ejb-16.0.0.1_BCM.jar:$CUSTOMER_MIGRATION_LIB/asi/core-platform-lib-16.0.0.1_BCM.jar:$CUSTOMER_MIGRATION_LIB/asi/core-platform-utility-16.0.0.1_BCM.jar:$CUSTOMER_MIGRATION_LIB/asi/core-services-client-stubs-16.0.0.1_BCM.jar:$CUSTOMER_MIGRATION_LIB/asi/ipex-services-client-stubs-16.0.0.1_BCM.jar:$CUSTOMER_MIGRATION_LIB/asi/obj-sync-services-client-stubs-16.0.0.1_BCM.jar:$CUSTOMER_MIGRATION_LIB/asi/rm-services-client-stubs-16.0.0.1_BCM.jar:$CUSTOMER_MIGRATION_LIB/asi/worx-services-client-stubs-16.0.0.1_BCM.jar

CUSTOMER_MIGRATION_CLASSPATH=$CUSTOMER_MIGRATION_HOME:$CUSTOMER_MIGRATION_HOME/dataMigration.jar:$CUSTOMER_MIGRATION_LOG4J:$CUSTOMER_MIGRATION_WL:$CUSTOMER_MIGRATION_ORACLE:$CUSTOMER_MIGRATION_ASI:$CUSTOMER_MIGRATION_CONFIG

echo "$JAVA_HOME/bin/java" -classpath "$CUSTOMER_MIGRATION_CLASSPATH" -Djava.security.egd=file:/dev/./urandom com.ericsson.stc.dataMigration.CustomerMigrationTool
"$JAVA_HOME/bin/java" -classpath "$CUSTOMER_MIGRATION_CLASSPATH" -Djava.security.egd=file:/dev/./urandom com.ericsson.stc.dataMigration.CustomerMigrationTool

