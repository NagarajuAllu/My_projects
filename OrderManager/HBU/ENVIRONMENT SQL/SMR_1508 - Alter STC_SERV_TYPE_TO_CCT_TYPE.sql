-- rename existing column CCT_TYPE to GRANITE_CCT_TYPE
alter table STC_SERV_TYPE_TO_CCT_TYPE rename column CCT_TYPE to GRANITE_CCT_TYPE;

-- add new column CCT_TYPE
alter table STC_SERV_TYPE_TO_CCT_TYPE add CCT_TYPE varchar2(25);

-- set a generic value for all the rows of the table
update STC_SERV_TYPE_TO_CCT_TYPE set CCT_TYPE = GRANITE_CCT_TYPE;
commit;

-- now the new column can be set NOT NULL
alter table STC_SERV_TYPE_TO_CCT_TYPE modify CCT_TYPE varchar2(25) not null;

-- changing the columns to put them in the correct sequence
alter table STC_SERV_TYPE_TO_CCT_TYPE rename column GRANITE_CCT_TYPE to GRANITE_CCT_TYPE1;
alter table STC_SERV_TYPE_TO_CCT_TYPE add GRANITE_CCT_TYPE varchar2(25);
update STC_SERV_TYPE_TO_CCT_TYPE set GRANITE_CCT_TYPE=GRANITE_CCT_TYPE1;
commit;
alter table STC_SERV_TYPE_TO_CCT_TYPE drop column GRANITE_CCT_TYPE1;

-- remove existing primary key & index
alter table STC_SERV_TYPE_TO_CCT_TYPE drop constraint STC_SERV_TYPE_TO_CCT_TYPE cascade;
drop index STC_SERV_TYPE_TO_CCT_TYPE;

-- create the new primary key with index (using the same name)
alter table STC_SERV_TYPE_TO_CCT_TYPE add constraint STC_SERV_TYPE_TO_CCT_TYPE primary key (service_type, cct_type) using index;


-- adding the rows from SIPMW
insert into STC_SERV_TYPE_TO_CCT_TYPE values ('SIP_TF', 'SIPMW', 'SIPMW');
insert into STC_SERV_TYPE_TO_CCT_TYPE values ('SIP_UAN', 'SIPMW', 'SIPMW');
insert into STC_SERV_TYPE_TO_CCT_TYPE values ('SIP_SN', 'SIPMW', 'SIPMW');
insert into STC_SERV_TYPE_TO_CCT_TYPE values ('DID_SIP', 'SIPMW', 'SIPMW');
commit;
