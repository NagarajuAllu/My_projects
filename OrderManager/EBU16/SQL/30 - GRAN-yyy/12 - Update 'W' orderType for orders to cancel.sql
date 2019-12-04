set serveroutput on;


DECLARE

  CURSOR order_w IS 
    SELECT h.ordernumber, h.ordertype, l.lineitemidentifier, l.lineitemstatus, l.cworderid
      FROM stc_lineitem l, stc_bundleorder_header h 
     WHERE l.cworderid = h.cworderid
       AND elementtypeinordertree = 'B'
       AND provisioningflag = 'PROVISIONING'
       AND orderType = 'W'
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
           
  errorMsg VARCHAR2(1000);
  
BEGIN

  DBMS_OUTPUT.ENABLE(NULL);
  
  FOR o IN order_w LOOP
    BEGIN
      UPDATE stc_bundleorder_header 
         SET orderType = 'I'
       WHERE orderNumber = o.orderNumber;
       
      UPDATE stc_lineitem
         SET action = 'A'
       WHERE cworderId = o.cworderid;
    
      DBMS_OUTPUT.PUT_LINE('Order '||o.orderNumber||' updated SUCCESSFULLY');

    EXCEPTION
      WHEN others THEN
        errorMsg := SUBSTR(sqlerrm, 1, 1000);
        
        DBMS_OUTPUT.PUT_LINE(' ---->>> Error in updating orderType for order '||o.orderNumber||'; error found: '||errorMsg);
    END;
  END LOOP;
END;
/


COMMIT;
