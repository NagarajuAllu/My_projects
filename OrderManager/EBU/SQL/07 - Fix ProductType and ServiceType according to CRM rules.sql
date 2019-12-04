-- Legacy Order: set ProductType := ServiceType

SELECT DISTINCT productType, serviceType
  FROM stc_lineitem
 WHERE elementTypeInOrderTree = 'B'
   AND NVL(productType, 'x') NOT IN (SELECT crmproducttype FROM stc_producttype_name_map)
   AND NVL(productType, 'x') <> serviceType;


UPDATE stc_lineitem
   SET productType = serviceType
 WHERE elementTypeInOrderTree = 'B'
   AND NVL(productType, 'x') NOT IN (SELECT crmproducttype FROM stc_producttype_name_map)
   AND NVL(productType, 'x') <> serviceType;
-- 183275 rows updated   
   
   
-- SIP Order: set ServiceType := ProductType for Bundle LineItem

SELECT DISTINCT productType, serviceType
  FROM stc_lineitem
 WHERE elementTypeInOrderTree = 'B'
   AND NVL(productType, 'x') IN (SELECT crmproducttype FROM stc_producttype_name_map)
   AND NVL(productType, 'x') <> NVL(serviceType, 'y');


UPDATE stc_lineitem
   SET serviceType = productType
 WHERE elementTypeInOrderTree = 'B'
   AND NVL(productType, 'x') IN (SELECT crmproducttype FROM stc_producttype_name_map)
   AND NVL(productType, 'x') <> NVL(serviceType, 'y');
-- 0 rows updated

    
-- SIP Order: set ServiceType := ProductType for Circuit LineItem
SELECT DISTINCT c.productType, c.serviceType
  FROM stc_lineitem b, stc_lineitem c
 WHERE b.elementTypeInOrderTree = 'B'
   AND c.elementTypeInOrderTree = 'C'
   AND c.cworderid = b.cworderid
   AND NVL(b.productType, 'x') IN (SELECT crmproducttype FROM stc_producttype_name_map)
   AND NVL(c.productType, 'x') <> NVL(c.serviceType, 'y');

UPDATE stc_lineitem
   SET productType = serviceType
 WHERE cwdocid IN (SELECT c.cwdocid
                     FROM stc_lineitem b, stc_lineitem c
                    WHERE b.elementTypeInOrderTree = 'B'
                      AND c.elementTypeInOrderTree = 'C'
                      AND c.cworderid = b.cworderid
                      AND NVL(b.productType, 'x') IN (SELECT crmproducttype FROM stc_producttype_name_map)
                      AND NVL(c.productType, 'x') <> NVL(c.serviceType, 'y'));
-- 2674 rows updated                      
                      
                      
-- SIP Order: set ServiceType := ProductType for Service LineItem
SELECT DISTINCT c.productType, c.serviceType
  FROM stc_lineitem b, stc_lineitem c
 WHERE b.elementTypeInOrderTree = 'B'
   AND c.elementTypeInOrderTree = 'S'
   AND c.cworderid = b.cworderid
   AND NVL(b.productType, 'x') IN (SELECT crmproducttype FROM stc_producttype_name_map)
   AND NVL(c.productType, 'x') <> NVL(c.serviceType, 'y');

UPDATE stc_lineitem
   SET productType = serviceType
 WHERE cwdocid IN (SELECT c.cwdocid
                     FROM stc_lineitem b, stc_lineitem c
                    WHERE b.elementTypeInOrderTree = 'B'
                      AND c.elementTypeInOrderTree = 'S'
                      AND c.cworderid = b.cworderid
                      AND NVL(b.productType, 'x') IN (SELECT crmproducttype FROM stc_producttype_name_map)
                      AND NVL(c.productType, 'x') <> NVL(c.serviceType, 'y'));
-- 2706 rows updated