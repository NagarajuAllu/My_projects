update stc_lineitem l
   set l.lineitemstatus = 'COMPLETED'
 where l.elementtypeinordertree <> 'B'
   and upper(l.lineitemstatus) in ('LIVE', 'DECOMMISSIONED')
   and l.cworderid in (select h.cworderid
                         from stc_bundleorder_header h
                        where h.ismigrated = 1
                          and h.cworderid = l.cworderid);
