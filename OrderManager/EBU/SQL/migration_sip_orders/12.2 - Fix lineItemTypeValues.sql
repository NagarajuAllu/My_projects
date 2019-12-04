update stc_lineitem l
   set l.lineitemtype = 'Bundle'
 where l.cworderid in (select l.cworderid
                         from stc_bundleorder_header h
                        where h.ismigrated = 1
                          and h.cworderid = l.cworderid)
   and l.elementtypeinordertree = 'B'
   and l.producttype in (select crmproducttype from stc_producttype_name_map m where m.internalproducttype ='Bundle SIP');
   
   
update stc_lineitem l
   set l.lineitemtype = 'Circuit'
 where l.cworderid in (select b.cworderid
                         from stc_bundleorder_header h, stc_lineitem b
                        where h.ismigrated = 1
                          and h.cworderid = b.cworderid
                          and b.elementtypeinordertree = 'B'
                          and b.producttype in (select crmproducttype from stc_producttype_name_map m where m.internalproducttype ='Bundle SIP'))
   and l.elementtypeinordertree = 'C';