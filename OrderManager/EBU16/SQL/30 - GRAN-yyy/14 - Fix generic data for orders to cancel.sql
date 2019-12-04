set serveroutput on;


DECLARE

  CURSOR orders_to_fix IS 
    SELECT h.ordernumber, h.ordertype, l.lineitemidentifier, l.lineitemstatus, l.cworderid, l.lineitemtype
      FROM stc_lineitem l, stc_bundleorder_header h 
     WHERE l.cworderid = h.cworderid
       AND elementtypeinordertree = 'B'
       AND provisioningflag = 'PROVISIONING'
       AND lineitemidentifier IN (
           'HAIL-HAIL-SIP2',
           'MAKKAH-MAKKAH SIPB5004',
           'JEDA02-JEDA02 SIP28',
           'JEDA04_21_301-JEDA04_21_301 SIPB3',
           'JEDA05-JEDA05 SIP18',
           'JEDA06_00_313-JEDA06_00_313 SIP2',
           'DMAM01_00_116-DMAM01_00_116 SIP1',
           'JEDDAH-JEDDAH SIP110',
           'RIYADH-RIYADH SIP458',
           'SHRFKHAE-SHRFKHAE SIP2',
           'JUBAIL-JUBAIL SIP22',
           'ALJOUF-ALJOUF SIP5',
           'DAMMAM-DAMMAM SIP21',
           'DAMMAM-DAMMAM SIP640',
           'BGDYKHAT-BGDYKHAT SIP2',
           'DAMMAM-DAMMAM SIP11',
           '12302393d6A23334Z',
           'RIYADH-RIYADH SIPB5005',
           'JEDDAH-JEDDAH SIPB5016',
           'SNYHEAAA-SNYHEAAA SIP5',
           'RYAD01-RYAD01 SIP7',
           'TABUK-TABUK SIP2',
           'RYAD02_00_207-RYAD02_00_207 SIP10',
           'RYAD02_00_207-RYAD02_00_207 SIP11',
           'RYAD02_00_207-RYAD02_00_207 SIP12',
           'RYAD02_00_207-RYAD02_00_207 SIP8',
           'RYAD02_00_207-RYAD02_00_207 SIP9',
           'RYAD08-RYAD08 SIP3',
           'RYAD13-RYAD13 SIP2',
           '12302393d6A23334',
           '12302393d6A23334Y',
           'JEDDAH-JEDDAH SIPB5012',
           'RYAD01-JEDDAH SIP101',
           'MGRFRDAA-MGRFRDAA SIP1',
           'RIYADH-RIYADH SIP228',
           'JEDDAH-JEDDAH SIP53',
           'JIZA03_41-JIZA03_41 SIP3',
           'RIYADH-RIYADH SIP285',
           'RIYADH-RIYADH SIP289',
           'JEDDAH-JEDDAH SIP73',
           'JNADRDAL-JNADRDAL SIP3',
           'RIYADH-RIYADH SIP68',
           'RIYADH-RIYADH SIP214',
           'RIYADH-RIYADH SIPB5095',
           'BAHA-BAHA SIPB5008',
           'MAKKAH-MAKKAH SIPB5028',
           'RIYADH-RIYADH SIPB5125',
           'BAHA-BAHA SIPB5009',
           'MAKKAH-MAKKAH SIPB5021',
           'MAKKAH-MAKKAH SIPB5010',
           'RIYADH-RIYADH SIPB5169',
           'RIYADH-RIYADH SIPB5142',
           'RIYADH-RIYADH SIPB5143',
           'RIYADH-RIYADH SIPB5112',
           'JEDDAH-JEDDAH SIPB5031',
           'JIZAN-JIZAN SIPB5002',
           'RIYADH-RIYADH SIPB5136',
           'RIYADH-RIYADH SIPB5075',
           'MAKKAH-MAKKAH SIPB5024',
           'RIYADH-RIYADH SIPB5176',
           'RIYADH-RIYADH SIPB5190',
           'JEDDAH-JEDDAH SIPB5095',
           'TABUK-TABUK SIPB5004',
           'RIYADH-RIYADH SIPB5116',
           'RIYADH-RIYADH SIPB5167',
           'ALJOUF-ALJOUF SIPB5001',
           'MAKKAH-MAKKAH SIPB5031',
           'RIYADH-RIYADH SIPB5066',
           'DAMMAM-DAMMAM SIPB5131',
           'JEDDAH-JEDDAH SIPB5306',
           'RIYADH-RIYADH SIPB5711',
           'JEDDAH-JEDDAH SIPB5365',
           'RIYADH-RIYADH SIPB5794',
           'NAJRAN-NAJRAN SIPB5012',
           'RIYADH-RIYADH SIPB5812',
           'RIYADH-RIYADH SIPB5683',
           'RIYADH-RIYADH SIPB5987',
           'JEDDAH-MAKKAH SIPB01',
           'TAIF-TAIF SIPB5043',
           'DAMMAM-DAMMAM SIPB5316',
           'JEDDAH-JEDDAH SIPB5331',
           'JEDDAH-JEDDAH SIPBMW5021',
           'JEDDAH-JEDDAH SIPB5589',
           'RIYADH-RIYADH SIPB6400',
           'JEDDAH-JEDDAH SIPB5475',
           'JEDDAH-JEDDAH SIPB5641',
           'RIYADH-RIYADH SIPB6353',
           'JEDDAH-JEDDAH SIPB10018',
           'RIYADH-RIYADH SIPB10022',
           'RIYADH-RIYADH SIPBMW5124',
           'BAHA-BAHA SIPB5047',
           'DAMMAM-DAMMAM SIPB5466',
           'JEDDAH-JEDDAH SIPB5691',
           'RIYADH-RIYADH SIPB10055',
           'JEDDAH-JEDDAH SIPB5685',
           'RIYADH-RIYADH SIPB6624',
           'DAMMAM-DAMMAM SIPB10028',
           'RIYADH-RIYADH SIPB10159',
           'RIYADH-RIYADH SIPB6629',
           'RIYADH-RIYADH SIPB6633BD',
           'QASSIM-QASSIM SIPB10000',
           'RIYADH-RIYADH SIPB10077',
           'TAIF-TAIF SIPB10000',
           'RIYADHDST-RIYADHDST SIPB5022',
           'ALAHSA-ALAHSA SIPB10013',
           'JUBAIL-JUBAIL SIPB10001',
           'JEDDAH-JEDDAH SIPB5729',
           'RIYADH-RIYADH SIPB10324',
           'RIYADHDST-RIYADHDST SIPB10020',
           'RIYADHDST-RIYADHDST SIPB10015',
           'RIYADH-RIYADH SIPB6235',
           'ABHA-ABHA SIPBMW5002',
           'RIYADHDST-RIYADHDST SIPB10009',
           'RIYADH-RIYADH SIPB6660BD',
           'RIYADH-RIYADH SIPB6661BD',
           'khobar-khobar SIPF1',
           'ZHWREAU0019-ZHWREAU0019 SIPF1',
           'JUBAIL-GF-JUBAIL-GF SIPF1',
           'Jeddah-Jeddah SIPMWF1',
           'JEDDAH-GF-JEDDAH-GF SIPMWF1',
           'KHOPAR-KHOPAR SIPF1',
           'RIYADH-RIYADH SIPF1',
           'MADINAH-GF-YANBU-MDIA-3748 SIPMWF1',
           'DAMMAM-GF-DAMMAM-GF SIPF1',
           'MADINAH-YANBU-GF SIPMWF1',
           'YNBUDNEJ-YNBUDNEJ SIPF1',
           'NDRYRDU0076-NDRYRDU0076 SIPF1',
           'APRTRRAE-APRTRRAE SIPF1',
           'ASIR-DIAS-1954-ASIR-DIAS-1954 SIPMWF1',
           'CITYRRAK-CITYRRAK SIPMWF1',
           'Riyadh-Riyadh SIPF1',
           'TABUK-TABUK SIPMWF1',
           'RIYADH-RIYADH SIPMWF1',
           'TABUK-TABUK SIPF1',
           'AAMJRDAA-- SIPF1',
           'RIYADH-GF-RIYADH-GF SIPF1',
           'jeddah-jeddah SIPF1',
           'riyadh-riyadh SIPF1',
           'Jeddah-jeddah SIPF1',
           'JMEDINA Prince Mohammad Bin Abdulaziz Airport-JMEDINA Prince Mohammad Bin Abdulaziz Airport SIPF1',
           'SLHNKHAK-SLHNKHAK BSIPMWF1',
           'SLMHKHBI-SLMHKHBI BSIPF1',
           'KADRDNU0001-KADRDNU0001 BSIPF1',
           'KAARKH00-KAARKH00 BSIPF1',
           'JBYLEA01-JBYLEA01 BSIPF1',
           'DHASEA00-MNTZEAAD SIPF1',
           'KKIARD00-KKIARD00 BSIPMWF1');
                      
  errorMsg       VARCHAR2(1000);
  
  service_number stc_lineitem.servicenumber%TYPE;
  wo_number      stc_lineitem.workordernumber%TYPE;
  
  path_id        NUMBER(10);
  cust_id_num    VARCHAR2(50);
  a_site_id      NUMBER(10);
  z_site_id      NUMBER(10);
  
  a_site_name    stc_lineitem.locationacclicode%TYPE;
  z_site_name    stc_lineitem.locationbcclicode%TYPE;
  
  account_number stc_bundleorder_header.accountNumber%TYPE;
  icms_so_number stc_lineitem.icmssonumber%TYPE;
  
BEGIN

  DBMS_OUTPUT.ENABLE(NULL);
  
  FOR o IN orders_to_fix LOOP
    BEGIN
      service_number := NULL;
      wo_number      := NULL;

      path_id        := NULL;
      cust_id_num    := '-';
      a_site_id      := NULL;
      z_site_id      := NULL;
      
      a_site_name    := '-';
      z_site_name    := '-';

      account_number := '-';
      icms_so_number := '-';
      
      -- extract path name
      IF(o.lineItemType = 'Root') THEN
        SELECT serviceNumber, workordernumber
          INTO service_number, wo_number
          FROM stc_lineitem
         WHERE cworderid = o.cworderid
           AND elementTypeInOrderTree = 'B';
      ELSE
        SELECT serviceNumber, workordernumber
          INTO service_number, wo_number 
          FROM stc_lineitem
         WHERE cworderid = o.cworderid
           AND elementTypeInOrderTree = 'C'
           AND rownum = 1;
      END IF;
      
      IF(service_number IS NOT NULL) THEN
        -- extract path info
        BEGIN
          SELECT circ_path_inst_id, customer_id, a_side_site_id, z_side_site_id
            INTO path_id, cust_id_num, a_site_id, z_site_id
            FROM circ_path_inst@rms_prod_db_link cpi
           WHERE cpi.circ_path_hum_id = service_number;
        EXCEPTION
          WHEN no_data_found THEN
            NULL;
        END;

        IF(path_id IS NULL) THEN
          -- extract path info from archive table
          BEGIN
            SELECT circ_path_inst_id, customer_id, a_side_site_id, z_side_site_id
              INTO path_id, cust_id_num, a_site_id, z_site_id
              FROM del_circ_path_inst@rms_prod_db_link cpi
             WHERE cpi.circ_path_hum_id = service_number;
          EXCEPTION
            WHEN no_data_found THEN
              NULL;
            WHEN too_many_rows THEN
              BEGIN
                SELECT circ_path_inst_id, customer_id, a_side_site_id, z_side_site_id
                  INTO path_id, cust_id_num, a_site_id, z_site_id
                  FROM del_circ_path_inst@rms_prod_db_link cpi
                 WHERE cpi.circ_path_hum_id = service_number
                   AND order_num = wo_number;
              EXCEPTION
                WHEN OTHERS THEN
                  NULL;
              END;
          END;
        END IF;
      END IF;
      
      IF(a_site_id IS NOT NULL) THEN
        -- extract site A info
        BEGIN
          SELECT site_hum_id
            INTO a_site_name
            FROM site_inst@rms_prod_db_link si
           WHERE site_inst_id = a_site_id;
           
        EXCEPTION
          WHEN no_data_found THEN
            a_site_name := '-';
        END;
      END IF;
      
      IF(z_site_id IS NOT NULL) THEN
        -- extract site Z info
        BEGIN
          SELECT site_hum_id
            INTO z_site_name
            FROM site_inst@rms_prod_db_link si
           WHERE site_inst_id = z_site_id;
           
        EXCEPTION
          WHEN no_data_found THEN
            z_site_name := '-';
        END;
      END IF;

      IF(path_id IS NOT NULL) THEN
        -- extract account number
        BEGIN
          SELECT attr_value
            INTO account_number
            FROM circ_path_attr_settings@rms_prod_db_link cpas, val_attr_name@rms_prod_db_link van
           WHERE cpas.circ_path_inst_id = path_id
             AND cpas.val_attr_inst_id = van.val_attr_inst_id
             AND van.attr_name = 'Account Number'
             AND van.group_name = 'Customer Details';
        EXCEPTION
          WHEN no_data_found THEN
            account_number := '-';
        END;
      END IF;
            
      IF(wo_number IS NOT NULL) THEN
        -- extract icms SO number
        BEGIN
          SELECT attr_value
            INTO icms_so_number
            FROM workorder_attr_settings@rms_prod_db_link woas, val_attr_name@rms_prod_db_link van, work_order_inst@rms_prod_db_link wo
           WHERE woas.workorder_inst_id = wo.wo_inst_id
             AND wo.wo_name = wo_number
             AND woas.val_attr_inst_id = van.val_attr_inst_id
             AND van.attr_name = 'ICMS S/O Number'
             AND van.group_name = 'Work Order Info';
        EXCEPTION
          WHEN no_data_found THEN
            icms_so_number := '-';
        END;
      END IF;

      UPDATE stc_lineitem
         SET icmssonumber = NVL(icmssonumber, icms_so_number),
             serviceDate = NVL(serviceDate, sysdate),
             creationDate = NVL(creationDate, to_date('01/01/2019', 'dd/mm/yyyy')),
             locationacclicode = NVL(locationacclicode, a_site_name),
             locationbcclicode = NVL(locationbcclicode, z_site_name)
       WHERE cworderId = o.cworderid;


      UPDATE stc_bundleorder_header 
         SET accountNumber = NVL(accountNumber, account_number),
             customeridnumber = NVL(customeridnumber, cust_id_num),
             serviceDate = NVL(serviceDate, sysdate),
             creationDate = NVL(creationDate, to_date('01/01/2019', 'dd/mm/yyyy'))             
       WHERE orderNumber = o.orderNumber;
       
    
      DBMS_OUTPUT.PUT_LINE('Order '||o.orderNumber||' updated SUCCESSFULLY');

    EXCEPTION
      WHEN others THEN
        errorMsg := SUBSTR(sqlerrm, 1, 1000);
        
        DBMS_OUTPUT.PUT_LINE(' ---->>> Error in updating info for order '||o.orderNumber||'; error found: '||errorMsg);
    END;
  END LOOP;
END;
/


COMMIT;
