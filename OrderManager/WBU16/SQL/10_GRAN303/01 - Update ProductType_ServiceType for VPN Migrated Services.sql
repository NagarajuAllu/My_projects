SET SERVEROUTPUT ON

DECLARE

  CURSOR vpn_services IS
    SELECT *
      FROM stcw_vpn_migration;

  errorMsg               VARCHAR2(1000);
  stopProcess            CHAR(1);
  foundBundleOrderNumber stcw_bundleorder_header.orderNumber%TYPE;
  foundProvisioningFlag  stcw_lineitem.provisioningFlag%TYPE;
  foundProvisioningBU    stcw_lineitem.provisioningBU%TYPE;
  foundDocId             stcw_lineitem.cwDocId%TYPE;
  foundProductType       stcw_lineitem.productType%TYPE;
  foundServiceType       stcw_lineitem.serviceType%TYPE;
  
  newProductType         stcw_lineitem.productType%TYPE;
  newServiceType         stcw_lineitem.serviceType%TYPE;
  
BEGIN

  DBMS_OUTPUT.ENABLE(NULL);
  

  FOR vpn_serv IN vpn_services LOOP
    BEGIN
      stopProcess := 'N';
      
      -- check PROCESSRESULT value; must be equals to 1
      IF(vpn_serv.processResult <> 1) THEN
        DBMS_OUTPUT.PUT_LINE('[ERR] The record <'||vpn_serv.origServiceNumber||','||vpn_serv.origWONumber||'> has PROCESSRESULT different from 1 ['||vpn_serv.processResult||']');
        stopProcess := 'Y';
      END IF;
    
      -- check origServiceNumber is part of a bundle ACTIVE or PROVISIONING
      IF(stopProcess = 'N') THEN
        BEGIN
          SELECT h.orderNumber, l.provisioningFlag
            INTO foundBundleOrderNumber, foundProvisioningFlag
            FROM stcw_lineitem l, stcw_bundleorder_header h
           WHERE l.serviceNumber = vpn_serv.origServiceNumber
             AND l.elementTypeInOrderTree <> 'B'
             AND l.cwOrderId IN (SELECT b.cwOrderId FROM stcw_lineItem b WHERE b.provisioningFlag in ('ACTIVE', 'PROVISIONING') AND b.elementTypeInOrderTree = 'B')
             AND h.cwOrderId = l.cwOrderId
             AND rownum <= 1;
        
          DBMS_OUTPUT.PUT_LINE('[ERR] Found a service with serviceNumber equals to ORIGSERVICENUMER ['||vpn_serv.origServiceNumber||'] in a bundle order ['||foundBundleOrderNumber||'] and provisioningFlag ['||foundProvisioningFlag||']');
          stopProcess := 'Y';
        EXCEPTION  
          WHEN no_data_found THEN
            NULL;
        END;
      END IF;
      
      -- check newServiceNumber is part of a bundle ACTIVE or PROVISIONING
      IF(stopProcess = 'N') THEN
        BEGIN
          SELECT h.orderNumber, l.provisioningFlag
            INTO foundBundleOrderNumber, foundProvisioningFlag
            FROM stcw_lineitem l, stcw_bundleorder_header h
           WHERE l.serviceNumber = vpn_serv.newServiceNumber
             AND l.elementTypeInOrderTree <> 'B'
             AND l.cwOrderId IN (SELECT b.cwOrderId FROM stcw_lineItem b WHERE b.provisioningFlag in ('ACTIVE', 'PROVISIONING') AND b.elementTypeInOrderTree = 'B')
             AND h.cwOrderId = l.cwOrderId
             AND rownum <= 1;
        
          DBMS_OUTPUT.PUT_LINE('[ERR] Found a service with serviceNumber equals to NEWSERVICENUMER ['||vpn_serv.newServiceNumber||'] in a bundle order ['||foundBundleOrderNumber||'] and provisioningFlag ['||foundProvisioningFlag||']');
          stopProcess := 'Y';
        EXCEPTION
          WHEN no_data_found THEN
            NULL;
        END;
      END IF;
    
      -- check origServiceNumber is in flat order ACTIVE or PROVISIONING
      IF(stopProcess = 'N') THEN
        BEGIN
          SELECT h.orderNumber, l.provisioningFlag
            INTO foundBundleOrderNumber, foundProvisioningFlag
            FROM stcw_lineitem l, stcw_bundleorder_header h
           WHERE l.serviceNumber = vpn_serv.origServiceNumber
             AND l.elementTypeInOrderTree = 'B'
             AND l.provisioningFlag in ('ACTIVE', 'PROVISIONING')
             AND h.cwOrderId = l.cwOrderId
             AND rownum <= 1;
        
          DBMS_OUTPUT.PUT_LINE('[ERR] Found a service with serviceNumber equals to ORIGSERVICENUMER ['||vpn_serv.origServiceNumber||'] and provisioningFlag ['||foundProvisioningFlag||']');
          stopProcess := 'Y';
        EXCEPTION
          WHEN no_data_found THEN
            NULL;
        END;
      END IF;

      -- check provisioningBU in flat order PROVISIONING for newServiceNumber
      IF(stopProcess = 'N') THEN
        BEGIN
          SELECT l.provisioningBU, l.cwdocid
            INTO foundProvisioningBU, foundDocId
            FROM stcw_lineitem l, stcw_bundleorder_header h
           WHERE l.serviceNumber = vpn_serv.newServiceNumber
             AND l.elementTypeInOrderTree = 'B'
             AND l.provisioningFlag = 'PROVISIONING'
             AND h.cwOrderId = l.cwOrderId;
        
          IF(foundProvisioningBU IS NULL) THEN
            DBMS_OUTPUT.PUT_LINE('[WARN] Found a service with serviceNumber ['||vpn_serv.newServiceNumber||'] and provisioningFlag [PROVISIONING] with provisioningBU empty; setting it to ''E''');
            UPDATE stcw_lineitem SET provisioningBU = 'E' WHERE cwDocId = foundDocId;
          ELSIF(foundProvisioningBU = 'W') THEN
            DBMS_OUTPUT.PUT_LINE('[ERR] Found a service with serviceNumber ['||vpn_serv.newServiceNumber||'] and provisioningFlag [PROVISIONING] with provisioningBU equals to ''W''');
            stopProcess := 'Y';
          ELSIF(foundProvisioningBU = 'E') THEN
            DBMS_OUTPUT.PUT_LINE('[ERR] Found a service with serviceNumber ['||vpn_serv.newServiceNumber||'] and provisioningFlag [PROVISIONING] with provisioningBU equals to ''E''');
            stopProcess := 'Y';
          END IF;

        EXCEPTION
          WHEN no_data_found THEN
            NULL;
        END;
      END IF;
    
      -- check provisioningBU in flat order ACTIVE for newServiceNumber
      IF(stopProcess = 'N') THEN
        BEGIN
          SELECT l.provisioningBU, l.cwdocid, l.productType, l.serviceType
            INTO foundProvisioningBU, foundDocId, foundProductType, foundServiceType
            FROM stcw_lineitem l, stcw_bundleorder_header h
           WHERE l.serviceNumber = vpn_serv.newServiceNumber
             AND l.elementTypeInOrderTree = 'B'
             AND l.provisioningFlag = 'ACTIVE'
             AND h.cwOrderId = l.cwOrderId;
        
          IF(foundProvisioningBU IS NULL) THEN
            DBMS_OUTPUT.PUT_LINE('[WARN] Found a service with serviceNumber ['||vpn_serv.newServiceNumber||'] and provisioningFlag [ACTIVE] with provisioningBU empty; setting it to ''E''');
            UPDATE stcw_lineitem SET provisioningBU = 'E' WHERE cwDocId = foundDocId;
          ELSIF(foundProvisioningBU = 'W') THEN
            DBMS_OUTPUT.PUT_LINE('[ERR] Found a service with serviceNumber ['||vpn_serv.newServiceNumber||'] and provisioningFlag [ACTIVE] with provisioningBU equals to ''W''');
            stopProcess := 'Y';
          END IF;

        EXCEPTION
          WHEN no_data_found THEN
            DBMS_OUTPUT.PUT_LINE('[ERR] Not able to find a service with serviceNumber ['||vpn_serv.newServiceNumber||'] and provisioningFlag [ACTIVE] in the system');
            stopProcess := 'Y';
        END;
      END IF;

    
      -- check provisioningBU in flat order PROVISIONING for newServiceNumber
      IF(stopProcess = 'N') THEN
        SELECT DECODE(foundProductType, 'C030', 'D058',
                                        'D024', 'D056',
                                        'D022', 'D053',
                                        'D020', 'D052',
                                        'D019', 'D055',
                                        'C031', 'C057',
                                        foundProductType)
          INTO newProductType
          FROM dual;
          
        BEGIN
          SELECT gi_servicetype
            INTO newServiceType
            FROM stcw_servicetype_name_map
           WHERE com_serviceType = newProductType;
        EXCEPTION
          WHEN no_data_found THEN
             newServiceType := newProductType;
        END;

        -- same info, no need to update
        IF(foundProductType = newProductType AND foundServiceType = newServiceType) THEN
          DBMS_OUTPUT.PUT_LINE('[INFO] Not updated record ['||foundDocId||'] for newServiceNumber ['||vpn_serv.newServiceNumber||'] because already OK '||
                                      'productCode <'||newProductType||'> [old: '||foundProductType||'];'||
                                      'serviceType <'||newServiceType||'> [old: '||foundServiceType||']');
        ELSE
          UPDATE stcw_lineItem
             SET productType = newProductType,
                 receivedServiceType = newProductType,
                 serviceType = newServiceType
           WHERE cwDocId = foundDocId;

          DBMS_OUTPUT.PUT_LINE('[INFO] Updated record ['||foundDocId||'] for newServiceNumber ['||vpn_serv.newServiceNumber||']: '||
                                    'productCode <'||newProductType||'> [old: '||foundProductType||'];'||
                                    'serviceType <'||newServiceType||'> [old: '||foundServiceType||']');
        END IF;
      END IF;
    
    EXCEPTION
      WHEN OTHERS THEN
        errorMsg := substr(sqlerrm, 1, 1000);
        DBMS_OUTPUT.PUT_LINE('[ERR] '|| vpn_serv.origServiceNumber ||' - Unexpected error: '||errorMsg);
    END;
  END LOOP;


END;
/