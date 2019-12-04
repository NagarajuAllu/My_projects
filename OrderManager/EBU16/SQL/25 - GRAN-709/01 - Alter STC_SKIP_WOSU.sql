/***

define DEFAULT_TABLESPACE_TABLE = CWE;
define DEFAULT_TABLESPACE_INDEX = CWE_NDX;

***/


define DEFAULT_TABLESPACE_TABLE = STC_DATA;
define DEFAULT_TABLESPACE_INDEX = STC_DATA;

alter table STC_SKIP_WOSU add TASK_OPERATION varchar2(25);
alter table STC_SKIP_WOSU add CRM_B2B number(1) default 1;
alter table STC_SKIP_WOSU add CRM_BAU number(1) default 1;

alter table STC_SKIP_WOSU 
  add constraint UK_STC_SKIP_WOSU unique (SERVICETYPE)
  using index
  tablespace &DEFAULT_TABLESPACE_INDEX;
  
create or replace trigger STC_SKIP_WOSU_INS_UPD before insert or update on STC_SKIP_WOSU
  for each row
declare

begin
 
   if :new.NV_PAIR_NAME is not null then
      if :new.TASK_OPERATION is not null then
         raise_application_error( -20001, 'Cannot set NV_PAIR_NAME and TASK_OPERATION at the same time' );
      end if;
   end if;

   if :new.NV_PAIR_VALUE is not null then
      if :new.NV_PAIR_NAME is null then
         raise_application_error( -20002, 'Cannot set NV_PAIR_VALUE if NV_PAIR_NAME is not set' );
      end if;
   end if;
end;
/
