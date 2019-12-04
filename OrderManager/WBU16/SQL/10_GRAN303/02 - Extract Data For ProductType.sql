SELECT h.orderNumber, h.orderStatus, to_char(h.completionDate, 'dd/mm/yyyy hh24:mi:ss') orderCompletionDate,
       b.lineItemIdentifier, b.productType, b.serviceType, b.receivedServiceType, b.serviceNumber, to_char(b.completionDate, 'dd/mm/yyyy hh24:mi:ss') pliCompletionDate,
       DECODE(b.lineItemType, 'Bundle', 'Y',
                                        'N') isBundle, b.provisioningBU, b.provisioningFlag,
       s.lineItemIdentifier, s.productType, s.serviceType, s.receivedServiceType, s.serviceNumber, to_char(s.completionDate, 'dd/mm/yyyy hh24:mi:ss') servCompletionDate,
       s.provisioningBU
  FROM stcw_bundleorder_header h, stcw_lineitem b, stcw_lineitem s
 WHERE b.cwOrderId = h.cwOrderId
   AND b.elementTypeInOrderTree = 'B'
   AND (b.productType            in ('C030', 'D024', 'D022', 'D020', 'D019', 'C031')
        OR b.receivedServiceType in ('C030', 'D024', 'D022', 'D020', 'D019', 'C031'))
   AND s.cwOrderId (+) = h.cwOrderId
   AND s.elementTypeInOrderTree (+) = 'C'
   AND (s.productType            (+) in ('C030', 'D024', 'D022', 'D020', 'D019', 'C031')
        OR s.receivedServiceType (+) in ('C030', 'D024', 'D022', 'D020', 'D019', 'C031'))
   AND h.cwOrderId IN (SELECT x.cwOrderId
                         FROM stcw_lineitem x
                        WHERE x.productType         in ('C030', 'D024', 'D022', 'D020', 'D019', 'C031')
                           OR x.receivedServiceType in ('C030', 'D024', 'D022', 'D020', 'D019', 'C031')
                       );