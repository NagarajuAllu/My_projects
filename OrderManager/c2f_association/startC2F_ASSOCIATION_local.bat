#actual bat-file (reads from database)

set JAVA_HOME=D:\install\unpack\jdk7u21

set C2F_ASSOCIATION_HOME=D:\install\unpack\IntelliJ_IDEA_Community_Edition_1503\workspace2\c2f_association
set C2F_ASSOCIATION_CONFIG=%C2F_ASSOCIATION_HOME%\config
set C2F_ASSOCIATION_LIB=%C2F_ASSOCIATION_HOME%\lib
set C2F_ASSOCIATION_LOG4J=%C2F_ASSOCIATION_LIB%\log4j\commons-logging-1.2.jar;%C2F_ASSOCIATION_LIB%\log4j\log4j.jar
set C2F_ASSOCIATION_WL=%C2F_ASSOCIATION_LIB%\wl\wlfullclient-12.1.2.jar
set C2F_ASSOCIATION_ORACLE=%C2F_ASSOCIATION_LIB%\oracle\ojdbc6.jar;%C2F_ASSOCIATION_LIB%\oracle\orai18n.jar;%C2F_ASSOCIATION_LIB%\oracle\orai18n-mapping.jar

set C2F_ASSOCIATION_ASI81=%C2F_ASSOCIATION_LIB%\asi81\asi-8.1.104.jar;%C2F_ASSOCIATION_LIB%\asi81\core-platform-ejb-8.1.104.jar;%C2F_ASSOCIATION_LIB%\asi81\core-platform-lib-8.1.104.jar;%C2F_ASSOCIATION_LIB%\asi81\core-platform-utility-8.1.104.jar;%C2F_ASSOCIATION_LIB%\asi81\core-services-client-stubs-8.1.104.jar;%C2F_ASSOCIATION_LIB%\asi81\ipex-services-client-stubs-8.1.104.jar;%C2F_ASSOCIATION_LIB%\asi81\obj-sync-services-client-stubs-8.1.104.jar;%C2F_ASSOCIATION_LIB%\asi81\rm-services-client-stubs-8.1.104.jar;%C2F_ASSOCIATION_LIB%\asi81\worx-services-client-stubs-8.1.104.jar
set C2F_ASSOCIATION_ASI=%C2F_ASSOCIATION_LIB%\asi\asi-16.0.0.1_BCM.jar;%C2F_ASSOCIATION_LIB%\asi\core-platform-ejb-16.0.0.1_BCM.jar;%C2F_ASSOCIATION_LIB%\asi\core-platform-lib-16.0.0.1_BCM.jar;%C2F_ASSOCIATION_LIB%\asi\core-platform-utility-16.0.0.1_BCM.jar;%C2F_ASSOCIATION_LIB%\asi\core-services-client-stubs-16.0.0.1_BCM.jar;%C2F_ASSOCIATION_LIB%\asi\ipex-services-client-stubs-16.0.0.1_BCM.jar;%C2F_ASSOCIATION_LIB%\asi\obj-sync-services-client-stubs-16.0.0.1_BCM.jar;%C2F_ASSOCIATION_LIB%\asi\rm-services-client-stubs-16.0.0.1_BCM.jar;%C2F_ASSOCIATION_LIB%\asi\worx-services-client-stubs-16.0.0.1_BCM.jar

set C2F_ASSOCIATION_CLASSPATH=%C2F_ASSOCIATION_HOME%;%C2F_ASSOCIATION_HOME%\c2f_association.jar;%C2F_ASSOCIATION_LOG4J%;%C2F_ASSOCIATION_WL%;%C2F_ASSOCIATION_ORACLE%;%C2F_ASSOCIATION_ASI%;%C2F_ASSOCIATION_CONFIG%

"%JAVA_HOME%\bin\java" -classpath "%C2F_ASSOCIATION_CLASSPATH%" com.ericsson.stc.c2f_association.CopperToFiberSiteMappingToolDb %1
