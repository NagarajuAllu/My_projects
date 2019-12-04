prompt Importing table STCW_OH_VALIDATION_MAP...

-- Configure OrderHeader for Install orders
insert into STCW_OH_VALIDATION_MAP (ORDERTYPE) values ('I');
update STCW_OH_VALIDATION_MAP 
   set CUSTOMERIDNUMBER = 1 ,
       ACCOUNTNUMBER = 1
 where ORDERTYPE = 'I';


-- Configure OrderHeader for Change orders
insert into STCW_OH_VALIDATION_MAP (ORDERTYPE) values ('C');
update STCW_OH_VALIDATION_MAP 
   set CUSTOMERIDNUMBER = 1 ,
       ACCOUNTNUMBER = 1
 where ORDERTYPE = 'C';


-- Configure OrderHeader for Permanent Disconnect orders
insert into STCW_OH_VALIDATION_MAP (ORDERTYPE) values ('O');
update STCW_OH_VALIDATION_MAP 
   set CUSTOMERIDNUMBER = 1 ,
       ACCOUNTNUMBER = 1
 where ORDERTYPE = 'O';


-- Configure OrderHeader for Feasibility orders
insert into STCW_OH_VALIDATION_MAP (ORDERTYPE) values ('F');
update STCW_OH_VALIDATION_MAP 
   set CUSTOMERIDNUMBER = 1 ,
       ACCOUNTNUMBER = 1,
       FEASIBILITYFOR = 1,
       RESERVATION = 1
 where ORDERTYPE = 'F';

commit;

prompt Done.