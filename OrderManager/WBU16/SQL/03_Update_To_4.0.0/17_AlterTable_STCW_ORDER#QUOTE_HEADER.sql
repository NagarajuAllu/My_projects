alter table stcw_order_header modify productcode varchar2(255);
alter table stcw_order_header add migrated number(1) default 0;

alter table stcw_quote_header modify productcode varchar2(255);
alter table stcw_quote_header add migrated number(1) default 0;
