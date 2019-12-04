DECLARE

  CURSOR items (orderId IN VARCHAR2) IS
    SELECT action, cwDocId, elementTypeInOrderTree, lineItemIdentifier
      FROM stc_lineitem
     WHERE cwOrderId = orderId;


  CURSOR nv_pairs (lineItemId IN VARCHAR2, orderId IN VARCHAR2) IS
    SELECT name, value, cwDocStamp, lastUpdatedDate, updatedBy, action
      FROM stc_name_value
     WHERE parentElementId = lineItemId
       AND cwOrderId = orderId;

  ordNumber                 stc_bundleorder_header.orderNumber%TYPE;
  ordNumLike                VARCHAR2(100);
  foundProductType          stc_lineItem.productType%TYPE;
  baseOrderId               stc_bundleorder_header.cwOrderId%TYPE;
  destOrderId               stc_bundleorder_header.cwOrderId%TYPE;
  destOrdCreationDate       stc_bundleorder_header.cwOrderCreationDate%TYPE;
  lineItemDocId             stc_lineItem.cwDocId%TYPE;
  lineItemParentId          stc_lineItem.cwParentId%TYPE;
  lineItemParentInstanceKey cwOrderItems.instanceKey%TYPE;
  count_nv                  NUMBER(4);
  docSeq                    NUMBER(16);
  parentDocSeqNVPair        NUMBER(16);
  counterNV                 NUMBER(4);
  mdType                    cwOrderItems.metadataType%TYPE;
  instKey                   cwOrderItems.instanceKey%TYPE;
  appendMdType              VARCHAR2(30);

BEGIN

  ordNumber  := '&Order_Number_To_Process';
  ordNumLike := ordNumber||'%';

dbms_output.put_line('OrderNumber = '||ordNumber);

  SELECT productType
    INTO foundProductType
    FROM stc_lineItem l, stc_bundleorder_header h
   WHERE l.cwOrderId = h.cwOrderId
     AND l.elementTypeInOrderTree = 'B'
     AND h.orderNumber = ordNumber;

  IF(foundProductType not in ('SIPB', 'SIPMWB')) THEN
    RAISE_APPLICATION_ERROR(-10000, 'Procedure works only for SIPB orders, while this one has productType = '||foundProductType);
  END IF;

  -- getting the cwOrderId of the order generated with submitOrder; it has the nameValues
  SELECT MIN(cwOrderId)
    INTO baseOrderId
    FROM stc_bundleorder_header
   WHERE ordernumber LIKE ordNumLike;

  SELECT cwOrderId, cwOrderCreationDate
    INTO destOrderId, destOrdCreationDate
    FROM stc_bundleorder_header
   WHERE ordernumber = ordNumber;

  SELECT cwDocSeq.nextVal
    INTO docSeq
    FROM dual;

  FOR i IN items(baseOrderId) LOOP
    BEGIN

      counterNV := 0;

      -- getting the identifier of the lineItem of the destination order
      SELECT l.cwDocId, l.cwParentId
        INTO lineItemDocId, lineItemParentId
        FROM stc_lineItem l
       WHERE l.lineItemIdentifier = i.lineItemIdentifier
         AND l.elementTypeInOrderTree = i.elementTypeInOrderTree
         AND l.cwOrderId = destOrderId;

      SELECT instanceKey
        INTO lineItemParentInstanceKey
        FROM cwOrderItems
       WHERE topOrderId = destOrderId
         AND itemId = lineItemParentId;

      SELECT COUNT(*)
        INTO count_nv
        FROM stc_name_value
       WHERE parentElementId = i.cwDocId
         AND cwOrderId = baseOrderId;

      IF(count_nv > 0) THEN
        -- exists at least 1 NV that has to be copied into the lineItem dest
        SELECT DECODE(i.elementTypeInOrderTree, 'C', 'bundleOrderSTC.bundles.circuits.circuitParameters',
                                                     'bundleOrderSTC.bundles.circuits.services.serviceParameters'),
               DECODE(i.elementTypeInOrderTree, 'C', lineItemParentInstanceKey||'.circuitParameters',
                                                     lineItemParentInstanceKey||'.serviceParameters'),
               DECODE(i.elementTypeInOrderTree, 'C', 'circuitParameter',
                                                     'serviceParameter')
          INTO mdType, instKey, appendMdType
          FROM dual;

        parentDocSeqNVPair := docSeq;

        -- insert into cwOrderItems the container for all NV pairs
        INSERT INTO cworderitems (toporderid,     parentid,          itemid,                       metadatatype,
                                  pos, instancekey,     hasattachment, order_creation_date)
                           VALUES(destOrderId,    lineItemParentId,  TO_CHAR(parentDocSeqNVPair),  mdType,
                                  1,   instKey,         0,             destOrdCreationDate);


        -- increase seqNumber
        docSeq := docSeq + 1;

        -- loop for NV pairs of the lineItem

        FOR n IN nv_pairs(i.cwDocId, baseOrderId) LOOP
          BEGIN

            counterNV := counterNV + 1;

            -- insert into stc_name_value

            INSERT INTO stc_name_value (name, value, cwdocstamp, cwdocid, lastupdateddate, cwordercreationdate,
                                        cworderid, cwparentid, updatedby, parentelementid, action)
              VALUES (n.name,               -- NAME
                      n.value,              -- VALUE
                      n.cwDocStamp,         -- CWDOCSTAMP
                      TO_CHAR(docSeq + 1),  -- CWDOCID
                      n.lastUpdatedDate,    -- LASTUPDATEDDATE
                      destOrdCreationDate,  -- CWORDERCREATIONDATE
                      destOrderId,          -- CWORDERID
                      TO_CHAR(docSeq),      -- CWPARENTID
                      n.updatedBy,          -- UPDATEDBY
                      lineItemDocId,        -- PARENTELEMENTID
                      n.action              -- ACTION
                     );

            -- insert into cwOrderItems the container for the NV pair
            INSERT INTO cworderitems (toporderid,     parentid,           itemid,           metadatatype,
                                      pos,        instancekey,             hasattachment, order_creation_date)
                               VALUES(destOrderId,    parentDocSeqNVPair, TO_CHAR(docSeq),  mdType,
                                      counterNV,  instKey||'.'||counterNV, 0,             destOrdCreationDate);


            -- insert into cwOrderItems the the NV pair
            INSERT INTO cworderitems (toporderid,     parentid,           itemid,            metadatatype,
                                      pos,        instancekey,                                hasattachment, order_creation_date)
                               VALUES(destOrderId,    TO_CHAR(docSeq),    TO_CHAR(docSeq+1), mdType||'.'||appendMdType,
                                      0,          instKey||'.'||counterNV||'.'||appendMdType, 4,             destOrdCreationDate);


            -- increase seqNumber
            docSeq := docSeq + 2;

          END;
        END LOOP;


      END IF;

    END;
  END LOOP;

END;

/