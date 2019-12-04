-- rename existing column CCT_TYPE to GRANITE_CCT_TYPE
alter table STC_ORDER_MESSAGE_HOME add ALREADY_CANCELLED number(1);

alter table STC_ORDER_MESSAGE_HOME_ARCHIVE add ALREADY_CANCELLED number(1);

commit;
