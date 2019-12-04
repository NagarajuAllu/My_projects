update stcw_quote_header set migrated = 8 where quantity > 1 and quote_status in ('Feasibility', 'Reservation') and cwordercreationdate < to_date('01/01/2013', 'dd/mm/yyyy');
commit;

update stcw_quote_header set migrated = 6 where quotenumber = '1-129562225#1' and rownum = 1;
update stcw_quote_header set migrated = 6 where quotenumber = '1-113515146#1' and rownum = 1;
update stcw_quote_header set migrated = 6 where quotenumber = '1-101136822#3' and rownum = 1;
commit;