drop table EBU_STATS;

create table EBU_STATS (
  MSG_ID           number(16),
  WHEN_RECEIVED    timestamp(6),
  CRM_ORDER_NUMBER varchar2(64),
  CRM_ORDER_TYPE   varchar2(10),
  PLI_SERVICE_TYPE varchar2(25),
  WO_NUMBER        varchar2(20),
  IS_SUBMIT        char(1),
  STATUS           varchar2(100),
  ERROR_CODE       varchar2(300),
  ERROR_DESCR      varchar2(4000)
);

  