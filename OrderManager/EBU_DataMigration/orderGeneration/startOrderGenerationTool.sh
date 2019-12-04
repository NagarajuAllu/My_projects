#! /bin/sh

JAVA_HOME=/usr/java/jdk1.7.0_91

ORDER_GENERATION_HOME=/app/bea/EOC/EBU_DataMigration/orderGeneration
ORDER_GENERATION_CONFIG=$ORDER_GENERATION_HOME/config
ORDER_GENERATION_LIB=$ORDER_GENERATION_HOME/lib
ORDER_GENERATION_LOG4J=$ORDER_GENERATION_LIB/log4j/log4j.jar
ORDER_GENERATION_ORACLE=$ORDER_GENERATION_LIB/oracle/ojdbc6.jar:$ORDER_GENERATION_LIB/oracle/orai18n.jar:$ORDER_GENERATION_LIB/oracle/orai18n-mapping.jar
ORDER_GENERATION_XPATH=$ORDER_GENERATION_LIB/xpath/commons-jxpath-1.3.jar

ORDER_GENERATION_CLASSPATH=$ORDER_GENERATION_HOME:$ORDER_GENERATION_HOME/orderGeneration.jar:$ORDER_GENERATION_LOG4J:$ORDER_GENERATION_ORACLE:$ORDER_GENERATION_XPATH:$ORDER_GENERATION_CONFIG

echo "$JAVA_HOME/bin/java" -classpath "$ORDER_GENERATION_CLASSPATH" -Djava.security.egd=file:/dev/./urandom com.ericsson.stc.orderGeneration.OrderGeneratorTool
"$JAVA_HOME/bin/java" -classpath "$ORDER_GENERATION_CLASSPATH" -Djava.security.egd=file:/dev/./urandom com.ericsson.stc.orderGeneration.OrderGeneratorTool

