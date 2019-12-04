alter table STCW_PRODUCTCODE add SEND_DISCONNECT_FOR_CANCEL number(1) default 0 not null;
alter table STCW_PRODUCTCODE add FEAS_APPROACH  varchar2(25) default 'DEFAULT' not null;
alter table STCW_PRODUCTCODE add constraint FEAS_APPROACH_VALUES check (FEAS_APPROACH in ('DEFAULT', 'ALL_OR_NOTHING'));
alter table STCW_PRODUCTCODE add REQUIRE_VALIDATION_BOS number(1) default 0 not null;
