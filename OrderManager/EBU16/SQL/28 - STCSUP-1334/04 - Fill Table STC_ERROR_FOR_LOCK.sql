insert into STC_ERROR_FOR_LOCK (CWDOCID, ERROR_DESCR) values ('1', 'ConnectionJDBC.getConnection() caught an SQL exception');
insert into STC_ERROR_FOR_LOCK (CWDOCID, ERROR_DESCR) select max(to_number(CWDOCID)) + 1, 'A lock exception occurred while checking the work order lock' from STC_ERROR_FOR_LOCK;
insert into STC_ERROR_FOR_LOCK (CWDOCID, ERROR_DESCR) select max(to_number(CWDOCID)) + 1, 'Could not prepare resource ''ebu_prod_rms_prod_granite' from STC_ERROR_FOR_LOCK;
insert into STC_ERROR_FOR_LOCK (CWDOCID, ERROR_DESCR) select max(to_number(CWDOCID)) + 1, 'EJB Exception: ; nested exception is:' from STC_ERROR_FOR_LOCK;
insert into STC_ERROR_FOR_LOCK (CWDOCID, ERROR_DESCR) select max(to_number(CWDOCID)) + 1, 'The database has that temporarily locked, please try again' from STC_ERROR_FOR_LOCK;
insert into STC_ERROR_FOR_LOCK (CWDOCID, ERROR_DESCR) select max(to_number(CWDOCID)) + 1, 'There was an error during locking' from STC_ERROR_FOR_LOCK;
insert into STC_ERROR_FOR_LOCK (CWDOCID, ERROR_DESCR) select max(to_number(CWDOCID)) + 1, 'Failed to lock object type' from STC_ERROR_FOR_LOCK;

commit;
