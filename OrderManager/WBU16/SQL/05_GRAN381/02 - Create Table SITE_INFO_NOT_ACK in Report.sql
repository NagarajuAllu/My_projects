create table site_info_not_ack (
  cwdocid  varchar2(16) not null,
  siteid   varchar2(30), 
  plateid  varchar2(50),
  evt_date date default sysdate,
  bu       varchar2(3))
tablespace USERS;
  
alter table site_info_not_ack
  add constraint PK_site_info_not_ack primary key (CWDOCID)
  using index 
  tablespace USERS;
  
grant select on site_info_not_ack to rms_prod;
grant insert on site_info_not_ack to rms_prod;


