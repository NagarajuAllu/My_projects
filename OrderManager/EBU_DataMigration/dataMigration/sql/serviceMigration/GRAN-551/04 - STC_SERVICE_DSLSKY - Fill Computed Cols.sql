update STC_SERVICE_DSLSKY
   set COMPUTED_SITE_A = decode(DESCRIPTION, 'RYD CTYمدينة الرياض', 'RIYADH-GF',
                                             'ALJOUF         الجوف', 'ALJOUF-GF',
                                             'AL JUBAIL     الجبيل', 'JUBAIL-GF',
                                             'RIYADH-GF'),
       COMPUTED_SITE_B = decode(DESCRIPTION, 'RYD CTYمدينة الرياض', 'RIYADH-GF',
                                             'ALJOUF         الجوف', 'ALJOUF-GF',
                                             'AL JUBAIL     الجبيل', 'JUBAIL-GF',
                                             'RIYADH-GF'),
       ORDER_NUMBER = 'I_MIGR_ICMS'||lpad(rownum, 4, '0');                                    