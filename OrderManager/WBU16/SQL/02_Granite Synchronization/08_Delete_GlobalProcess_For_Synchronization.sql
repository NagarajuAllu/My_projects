delete from cwglobalprocess p where p.process_metadatype = (select typeid from cwmdtypes where typename = 'stcw.globalSyncAllOrdersBetweenExpediterAndGranite');
commit;
