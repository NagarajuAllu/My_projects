create sequence STC_OE_ORDER_NO_SEQ
minvalue 1
maxvalue 99999999
start with 1000000
increment by 1
cache 20;
/

CREATE OR REPLACE FUNCTION STC_OE_GEN_ORDER_NO (order_type IN VARCHAR2, USER_INTITIALS IN VARCHAR2)
RETURN VARCHAR2 IS
  cursor order_no_cursor (order_type IN VARCHAR2, user_initials IN VARCHAR2) IS
    select stc_oe_order_no_seq.nextval from dual;
  order_count number;
  order_no varchar2(12);
BEGIN
  open order_no_cursor(order_type, USER_INTITIALS);
  fetch order_no_cursor into order_count;
  order_no := order_type || to_char(order_count);
  close order_no_cursor;
  RETURN (order_no);
END;
/