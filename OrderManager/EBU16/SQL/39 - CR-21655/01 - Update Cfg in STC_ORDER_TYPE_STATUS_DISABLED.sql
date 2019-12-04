delete from STC_ORDER_TYPE_STATUS_DISABLED where ORDERTYPE in ('D', 'E') and ORDERSTATUS = 'CANCEL';
commit;
