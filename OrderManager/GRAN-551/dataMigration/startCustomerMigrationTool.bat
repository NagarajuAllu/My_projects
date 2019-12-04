set JAVA_HOME=C:\Program Files\Java\jdk1.7.0_75

set DATA_MIGRATION_HOME=C:\development\STC\16.0\GRAN-551\dataMigration
set DATA_MIGRATION_CONFIG=%DATA_MIGRATION_HOME%\config
set DATA_MIGRATION_LIB=%DATA_MIGRATION_HOME%\lib
set DATA_MIGRATION_LOG4J=%DATA_MIGRATION_LIB%\log4j\commons-logging-1.2.jar;%DATA_MIGRATION_LIB%\log4j\log4j.jar
set DATA_MIGRATION_WL=%DATA_MIGRATION_LIB%\wl\wlfullclient-12.1.2.jar
set DATA_MIGRATION_ORACLE=%DATA_MIGRATION_LIB%\oracle\ojdbc6.jar;%DATA_MIGRATION_LIB%\oracle\orai18n.jar;%DATA_MIGRATION_LIB%\oracle\orai18n-mapping.jar

set DATA_MIGRATION_ASI81=%DATA_MIGRATION_LIB%\asi81\asi-8.1.104.jar;%DATA_MIGRATION_LIB%\asi81\core-platform-ejb-8.1.104.jar;%DATA_MIGRATION_LIB%\asi81\core-platform-lib-8.1.104.jar;%DATA_MIGRATION_LIB%\asi81\core-platform-utility-8.1.104.jar;%DATA_MIGRATION_LIB%\asi81\core-services-client-stubs-8.1.104.jar;%DATA_MIGRATION_LIB%\asi81\ipex-services-client-stubs-8.1.104.jar;%DATA_MIGRATION_LIB%\asi81\obj-sync-services-client-stubs-8.1.104.jar;%DATA_MIGRATION_LIB%\asi81\rm-services-client-stubs-8.1.104.jar;%DATA_MIGRATION_LIB%\asi81\worx-services-client-stubs-8.1.104.jar
set DATA_MIGRATION_ASI=%DATA_MIGRATION_LIB%\asi\asi-16.0.0.1_BCM.jar;%DATA_MIGRATION_LIB%\asi\core-platform-ejb-16.0.0.1_BCM.jar;%DATA_MIGRATION_LIB%\asi\core-platform-lib-16.0.0.1_BCM.jar;%DATA_MIGRATION_LIB%\asi\core-platform-utility-16.0.0.1_BCM.jar;%DATA_MIGRATION_LIB%\asi\core-services-client-stubs-16.0.0.1_BCM.jar;%DATA_MIGRATION_LIB%\asi\ipex-services-client-stubs-16.0.0.1_BCM.jar;%DATA_MIGRATION_LIB%\asi\obj-sync-services-client-stubs-16.0.0.1_BCM.jar;%DATA_MIGRATION_LIB%\asi\rm-services-client-stubs-16.0.0.1_BCM.jar;%DATA_MIGRATION_LIB%\asi\worx-services-client-stubs-16.0.0.1_BCM.jar

set DATA_MIGRATION_CLASSPATH=%DATA_MIGRATION_HOME%;%DATA_MIGRATION_HOME%\dataMigration.jar;%DATA_MIGRATION_LOG4J%;%DATA_MIGRATION_WL%;%DATA_MIGRATION_ORACLE%;%DATA_MIGRATION_ASI81%;%DATA_MIGRATION_CONFIG%

"%JAVA_HOME%\bin\java" -classpath "%DATA_MIGRATION_CLASSPATH%" com.ericsson.stc.dataMigration.CustomerMigrationTool
