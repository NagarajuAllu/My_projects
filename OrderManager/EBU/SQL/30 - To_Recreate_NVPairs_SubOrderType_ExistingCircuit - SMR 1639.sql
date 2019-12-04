DECLARE
  
  CURSOR orders IS
    SELECT o.orderNumber, o.cwOrderId, o.cwOrderCreationDate
      FROM stc_bundleorder_header o, stc_lineitem l
     WHERE o.cwOrderId = l.cwOrderId
       AND l.provisioningFlag = 'PROVISIONING'
       AND l.elementTypeInOrderTree = 'B';


  CURSOR items (orderId IN VARCHAR2) IS
    SELECT action, cwDocId, elementTypeInOrderTree, lineItemIdentifier
      FROM stc_lineitem
     WHERE cwOrderId = orderId;

  ordNumLike                VARCHAR2(100);
  baseOrderId               stc_bundleorder_header.cwOrderId%TYPE;
  destOrderId               stc_bundleorder_header.cwOrderId%TYPE;
  destOrdCreationDate       stc_bundleorder_header.cwOrderCreationDate%TYPE;
  lineItemDocId             stc_lineItem.cwDocId%TYPE;
  lineItemParentId          stc_lineItem.cwParentId%TYPE;
  lineItemParentInstanceKey cwOrderItems.instanceKey%TYPE;

  docSeq                    NUMBER(16);
  count_nv_base             NUMBER(1);
  count_nv_dest             NUMBER(4);

  parentDocSeqNVPair        NUMBER(16);
  mdType                    cwOrderItems.metadataType%TYPE;
  instKey                   cwOrderItems.instanceKey%TYPE;
  appendMdType              VARCHAR2(80);

  TYPE NVPairList IS TABLE OF VARCHAR2(128);
  my_nvPairs NVPairList;

BEGIN
  
  dbms_output.enable(null);

  my_nvPairs := NVPairList('Sub Order Type', 'Existing Circuit');

  FOR o in orders LOOP
    BEGIN
      ordNumLike          := o.orderNumber||'\_%\_201%';
      destOrderId         := o.cwOrderId;
      destOrdCreationDate := o.cwOrderCreationDate;

dbms_output.put_line('OrderNumber = '||o.orderNumber);


      -- getting the cwOrderId of the order generated with submitOrder; it should have the nameValues
      SELECT MIN(cwOrderId)
        INTO baseOrderId
        FROM stc_bundleorder_header
       WHERE ordernumber LIKE ordNumLike ESCAPE '\';

      IF(baseOrderId = destOrderId) THEN
dbms_output.put_line('  base and dest order are the same so skipping');
        CONTINUE;
      END IF;

      SELECT cwDocSeq.nextVal
        INTO docSeq
        FROM dual;

      FOR i IN items(baseOrderId) LOOP
        BEGIN

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

          FOR nv IN my_nvPairs.FIRST .. my_nvPairs.LAST LOOP
            BEGIN
              -- check if i-th nameValue pair exists in the base order
              SELECT COUNT(*)
                INTO count_nv_base
                FROM stc_name_value
               WHERE parentElementId = i.cwDocId
                 AND cwOrderId = baseOrderId
                 AND name = my_nvPairs(nv);

              IF(count_nv_base > 0) THEN
                -- check if i-th nameValue pair exists in the dest order
                SELECT COUNT(*)
                  INTO count_nv_dest
                  FROM stc_name_value
                 WHERE parentElementId = lineItemDocId
                   AND cwOrderId = destOrderId
                   AND name = my_nvPairs(nv);

                IF(count_nv_dest = 0) THEN
                  -- the nv pair is missing in the dest order

                  -- checking if there are nv pairs under the lineItem
                  SELECT COUNT(*)
                    INTO count_nv_dest
                    FROM stc_name_value
                   WHERE parentElementId = lineItemDocId
                     AND cwOrderId = destOrderId;

                  SELECT DECODE(i.elementTypeInOrderTree, 'B', 'bundleOrderSTC.bundles.bundleParameters',
                                                          'C', 'bundleOrderSTC.bundles.circuits.circuitParameters',
                                                               'bundleOrderSTC.bundles.circuits.services.serviceParameters'),
                         DECODE(i.elementTypeInOrderTree, 'B', lineItemParentInstanceKey||'.bundleParameters',
                                                          'C', lineItemParentInstanceKey||'.circuitParameters',
                                                               lineItemParentInstanceKey||'.serviceParameters'),
                         DECODE(i.elementTypeInOrderTree, 'B', 'bundleParameter',
                                                          'C', 'circuitParameter',
                                                               'serviceParameter')
                    INTO mdType, instKey, appendMdType
                    FROM dual;

                  IF(count_nv_dest = 0) THEN
                    -- there isn't the container of the NV pairs; re-adding it!

                    parentDocSeqNVPair := docSeq;

                    -- insert into cwOrderItems the container for all NV pairs
                    INSERT INTO cworderitems (toporderid,     parentid,          itemid,                       metadatatype,
                                              pos, instancekey,     hasattachment, order_creation_date)
                                       VALUES(destOrderId,    lineItemParentId,  TO_CHAR(parentDocSeqNVPair),  mdType,
                                              1,   instKey,         0,             destOrdCreationDate);

                    -- increase seqNumber
                    docSeq := docSeq + 1;
                  ELSE
                    SELECT itemId
                      INTO parentDocSeqNVPair
                      FROM cworderitems
                     WHERE parentId = lineItemParentId
                       AND metadatatype = mdType;
                  END IF; -- creating container

                  count_nv_dest := count_nv_dest + 1;

                  -- insert into stc_name_value
                  INSERT INTO stc_name_value (name, value, cwdocstamp, cwdocid, lastupdateddate, cwordercreationdate,
                                              cworderid, cwparentid, updatedby, parentelementid, action)
                  SELECT name,                  -- NAME
                         value,                 -- VALUE
                         cwDocStamp,            -- CWDOCSTAMP
                         TO_CHAR(docSeq + 1),   -- CWDOCID
                         lastUpdatedDate,       -- LASTUPDATEDDATE
                         destOrdCreationDate,   -- CWORDERCREATIONDATE
                         destOrderId,           -- CWORDERID
                         TO_CHAR(docSeq),       -- CWPARENTID
                         updatedBy,             -- UPDATEDBY
                         lineItemDocId,         -- PARENTELEMENTID
                         action                 -- ACTION
                    FROM stc_name_value
                   WHERE parentElementId = i.cwDocId
                     AND cwOrderId = baseOrderId
                     AND name = my_nvPairs(nv);

dbms_output.put_line('  Re-Adding NV Pair '||my_nvPairs(nv)||' to lineItem '||i.lineItemIdentifier||'['||i.elementTypeInOrderTree||']');

                  -- insert into cwOrderItems the container for the NV pair
                  INSERT INTO cworderitems (toporderid,     parentid,           itemid,           metadatatype,
                                            pos,            instancekey,                 hasattachment, order_creation_date)
                                     VALUES(destOrderId,    parentDocSeqNVPair, TO_CHAR(docSeq),  mdType,
                                            count_nv_dest,  instKey||'.'||count_nv_dest, 0,             destOrdCreationDate);


                  -- insert into cwOrderItems the NV pair
                  INSERT INTO cworderitems (toporderid,     parentid,           itemid,            metadatatype,
                                            pos,        instancekey,                                    hasattachment, order_creation_date)
                                     VALUES(destOrderId,    TO_CHAR(docSeq),    TO_CHAR(docSeq+1), mdType||'.'||appendMdType,
                                            0,          instKey||'.'||count_nv_dest||'.'||appendMdType, 4,             destOrdCreationDate);

                  -- increase seqNumber
                  docSeq := docSeq + 2;

                END IF; -- creating nv pair in destination order
              END IF; -- check nv pair in base order
            END;
          END LOOP; -- end loop on nv pairs

        END;
      END LOOP; -- end loop on items

    END;
  END LOOP; -- end loop on orders

END;
/