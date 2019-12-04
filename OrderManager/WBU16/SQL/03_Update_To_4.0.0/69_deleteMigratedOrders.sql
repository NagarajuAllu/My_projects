declare

  cursor orderIds is
    select cworderid
      from stcw_bundleorder_header
     where ismigrated = 1;

begin

  for o in orderIds loop
    DELETE FROM cworderinstance WHERE cwdocid = o.cworderid;
    DELETE FROM stcw_namevalue WHERE cworderid = o.cworderid;
    DELETE FROM stcw_lineitem WHERE cworderid = o.cworderid;
    DELETE FROM stcw_bundleorder_header WHERE cworderid = o.cworderid;
    DELETE FROM stcw_order_orchestration WHERE cworderid = o.cworderid;
  end loop;
end;
/