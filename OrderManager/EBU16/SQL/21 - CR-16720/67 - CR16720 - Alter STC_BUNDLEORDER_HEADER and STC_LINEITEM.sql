alter table STC_BUNDLEORDER_HEADER modify icmssalesordernumber varchar2(19);
alter table STC_DEL_BUNDLEORDER_HEADER modify icmssalesordernumber varchar2(19);

alter table STC_LINEITEM modify icmssonumber varchar2(19);
alter table STC_DEL_LINEITEM modify icmssonumber varchar2(19);