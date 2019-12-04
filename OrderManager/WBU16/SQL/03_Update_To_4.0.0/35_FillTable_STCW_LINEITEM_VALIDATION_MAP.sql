prompt Importing table STCW_LINEITEM_VALIDATION_MAP...

-- Configure LineItem for Install orders
insert into STCW_LINEITEM_VALIDATION_MAP (ORDERTYPE, SERVICETYPE) values ('I', '*');
update STCW_LINEITEM_VALIDATION_MAP 
   set SEGMENTFLAG = 1,
       PRODUCTCODE = 1
 where ORDERTYPE = 'I'
   AND SERVICETYPE = '*';

-- Configure LineItem for Change orders
insert into STCW_LINEITEM_VALIDATION_MAP (ORDERTYPE, SERVICETYPE) values ('C', '*');
update STCW_LINEITEM_VALIDATION_MAP 
   set SERVICENUMBER = 1,
       CHANGEREQUESTTYPE = 1,
       SEGMENTFLAG = 1,
       PRODUCTCODE = 1
 where ORDERTYPE = 'C'
   AND SERVICETYPE = '*';


-- Configure LineItem for Permanent Disconnect orders
insert into STCW_LINEITEM_VALIDATION_MAP (ORDERTYPE, SERVICETYPE) values ('O', '*');
update STCW_LINEITEM_VALIDATION_MAP 
   set SERVICENUMBER = 1,
       SEGMENTFLAG = 1,
       PRODUCTCODE = 1
 where ORDERTYPE = 'O'
   AND SERVICETYPE = '*';


-- Configure LineItem for Feasibility orders
insert into STCW_LINEITEM_VALIDATION_MAP (ORDERTYPE, SERVICETYPE) values ('F', '*');
update STCW_LINEITEM_VALIDATION_MAP 
   set ORDERROWITEMID = 1,
       QUANTITY = 1,
       PRODUCTCODE = 1
 where ORDERTYPE = 'F'
   AND SERVICETYPE = '*';

commit;

prompt Done.