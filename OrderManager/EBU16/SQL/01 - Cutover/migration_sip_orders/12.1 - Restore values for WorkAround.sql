update stc_bundleorder_header h
   set h.customername = (select w.customername
                           from stc_sip_workaround_data w
                          where w.cworderid = h.customername)
 where h.ordernumber in (select parentordernumber
                           from stc_om_home_sip);
   
   
update stc_lineitem l
   set l.servicedescription = (select w.servicedescription
                                 from stc_sip_workaround_data w
                                 where w.cworderid = l.servicedescription)
 where l.cworderid in (select h.cworderid
                         from stc_bundleorder_header h, stc_om_home_sip o
                        where h.ordernumber = o.parentordernumber)
   and l.elementtypeinordertree in ('C', 'S');
   
   
