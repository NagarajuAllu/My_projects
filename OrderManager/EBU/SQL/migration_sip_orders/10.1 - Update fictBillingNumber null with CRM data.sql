update stc_om_home_sip o
   set o.fictbillingnumber = (select c.circuitfictb#
                                from stc_sip_crm_data c
                               where c.circuitnumber = o.circuitnumber)
 where o.fictbillingnumber is null;
 