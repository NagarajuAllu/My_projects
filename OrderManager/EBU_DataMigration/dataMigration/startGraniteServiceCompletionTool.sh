#! /bin/sh

JAVA_HOME=/usr/java/jdk1.7.0_91

GRANITE_COMPLETION_HOME=/app/bea/EOC/EBU_DataMigration/dataMigration
GRANITE_COMPLETION_CONFIG=$GRANITE_COMPLETION_HOME/config
GRANITE_COMPLETION_LIB=$GRANITE_COMPLETION_HOME/lib
GRANITE_COMPLETION_LOG4J=$GRANITE_COMPLETION_LIB/log4j/commons-logging-1.2.jar:$GRANITE_COMPLETION_LIB/log4j/log4j.jar
GRANITE_COMPLETION_WL=$GRANITE_COMPLETION_LIB/wl/wlfullclient-12.1.2.jar
GRANITE_COMPLETION_ORACLE=$GRANITE_COMPLETION_LIB/oracle/ojdbc6.jar:$GRANITE_COMPLETION_LIB/oracle/orai18n.jar:$GRANITE_COMPLETION_LIB/oracle/orai18n-mapping.jar
GRANITE_COMPLETION_XPATH=$GRANITE_COMPLETION_LIB/xpath/commons-jxpath-1.3.jar

GRANITE_COMPLETION_ASI=$GRANITE_COMPLETION_LIB/asi/asi-16.0.0.1_BCM.jar:$GRANITE_COMPLETION_LIB/asi/core-platform-ejb-16.0.0.1_BCM.jar:$GRANITE_COMPLETION_LIB/asi/core-platform-lib-16.0.0.1_BCM.jar:$GRANITE_COMPLETION_LIB/asi/core-platform-utility-16.0.0.1_BCM.jar:$GRANITE_COMPLETION_LIB/asi/core-services-client-stubs-16.0.0.1_BCM.jar:$GRANITE_COMPLETION_LIB/asi/ipex-services-client-stubs-16.0.0.1_BCM.jar:$GRANITE_COMPLETION_LIB/asi/obj-sync-services-client-stubs-16.0.0.1_BCM.jar:$GRANITE_COMPLETION_LIB/asi/rm-services-client-stubs-16.0.0.1_BCM.jar:$GRANITE_COMPLETION_LIB/asi/worx-services-client-stubs-16.0.0.1_BCM.jar

GRANITE_COMPLETION_CLASSPATH=$GRANITE_COMPLETION_HOME:$GRANITE_COMPLETION_HOME/dataMigration.jar:$GRANITE_COMPLETION_LOG4J:$GRANITE_COMPLETION_WL:$GRANITE_COMPLETION_ORACLE:$GRANITE_COMPLETION_XPATH:$GRANITE_COMPLETION_ASI:$GRANITE_COMPLETION_CONFIG

echo "$JAVA_HOME/bin/java" -classpath "$GRANITE_COMPLETION_CLASSPATH" -Djava.security.egd=file:/dev/./urandom com.ericsson.stc.dataMigration.GraniteCompletionTool
"$JAVA_HOME/bin/java" -classpath "$GRANITE_COMPLETION_CLASSPATH" -Djava.security.egd=file:/dev/./urandom com.ericsson.stc.dataMigration.GraniteCompletionTool

