set JAVA_HOME=C:\Program Files\Java\jdk1.7.0_75

set GRANITE_COMPLETION_HOME=C:\development\STC\16.0\EBU_DataMigration\dataMigration
set GRANITE_COMPLETION_CONFIG=%GRANITE_COMPLETION_HOME%\config
set GRANITE_COMPLETION_LIB=%GRANITE_COMPLETION_HOME%\lib
set GRANITE_COMPLETION_LOG4J=%GRANITE_COMPLETION_LIB%\log4j\commons-logging-1.2.jar;%GRANITE_COMPLETION_LIB%\log4j\log4j.jar
set GRANITE_COMPLETION_WL=%GRANITE_COMPLETION_LIB%\wl\wlfullclient-12.1.2.jar
set GRANITE_COMPLETION_ORACLE=%GRANITE_COMPLETION_LIB%\oracle\ojdbc6.jar;%GRANITE_COMPLETION_LIB%\oracle\orai18n.jar;%GRANITE_COMPLETION_LIB%\oracle\orai18n-mapping.jar

set GRANITE_COMPLETION_ASI81=%GRANITE_COMPLETION_LIB%\asi81\asi-8.1.104.jar;%GRANITE_COMPLETION_LIB%\asi81\core-platform-ejb-8.1.104.jar;%GRANITE_COMPLETION_LIB%\asi81\core-platform-lib-8.1.104.jar;%GRANITE_COMPLETION_LIB%\asi81\core-platform-utility-8.1.104.jar;%GRANITE_COMPLETION_LIB%\asi81\core-services-client-stubs-8.1.104.jar;%GRANITE_COMPLETION_LIB%\asi81\ipex-services-client-stubs-8.1.104.jar;%GRANITE_COMPLETION_LIB%\asi81\obj-sync-services-client-stubs-8.1.104.jar;%GRANITE_COMPLETION_LIB%\asi81\rm-services-client-stubs-8.1.104.jar;%GRANITE_COMPLETION_LIB%\asi81\worx-services-client-stubs-8.1.104.jar
set GRANITE_COMPLETION_ASI=%GRANITE_COMPLETION_LIB%\asi\asi-16.0.0.1_BCM.jar;%GRANITE_COMPLETION_LIB%\asi\core-platform-ejb-16.0.0.1_BCM.jar;%GRANITE_COMPLETION_LIB%\asi\core-platform-lib-16.0.0.1_BCM.jar;%GRANITE_COMPLETION_LIB%\asi\core-platform-utility-16.0.0.1_BCM.jar;%GRANITE_COMPLETION_LIB%\asi\core-services-client-stubs-16.0.0.1_BCM.jar;%GRANITE_COMPLETION_LIB%\asi\ipex-services-client-stubs-16.0.0.1_BCM.jar;%GRANITE_COMPLETION_LIB%\asi\obj-sync-services-client-stubs-16.0.0.1_BCM.jar;%GRANITE_COMPLETION_LIB%\asi\rm-services-client-stubs-16.0.0.1_BCM.jar;%GRANITE_COMPLETION_LIB%\asi\worx-services-client-stubs-16.0.0.1_BCM.jar

set GRANITE_COMPLETION_CLASSPATH=%GRANITE_COMPLETION_HOME%;%GRANITE_COMPLETION_HOME%\dataMigration.jar;%GRANITE_COMPLETION_LOG4J%;%GRANITE_COMPLETION_WL%;%GRANITE_COMPLETION_ORACLE%;%GRANITE_COMPLETION_ASI81%;%GRANITE_COMPLETION_CONFIG%

"%JAVA_HOME%\bin\java" -classpath "%GRANITE_COMPLETION_CLASSPATH%" com.ericsson.stc.dataMigration.GraniteCompletionTool
