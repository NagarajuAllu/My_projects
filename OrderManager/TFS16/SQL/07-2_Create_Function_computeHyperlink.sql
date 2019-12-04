CREATE OR REPLACE FUNCTION computeHyperlink(objectType IN VARCHAR2, objectId IN VARCHAR2, hyperlinkAttrName IN VARCHAR2) RETURN VARCHAR2
IS

  hyperlink VARCHAR2(1000);
  graniteURL VARCHAR2(500);

BEGIN

  graniteURL := 'http://eaiptd1.stc.com.sa:7777/pls/rms_prod/';

  IF(objectType = 'BI') THEN
    hyperlink := graniteURL||'xweb_site.site_def?siteInstId='||objectId;
  ELSIF(objectType = 'PRNR') THEN
    hyperlink := graniteURL||'xperweb.path_def?iPathInstId='||objectId;
  ELSIF(objectType = 'PRN') THEN
    hyperlink := graniteURL||'xweb_cust.cust_def?iCustomerId='||objectId;
  ELSIF(objectType = 'TFR') THEN
    hyperlink := graniteURL||'xweb_equip.equip_def?iEqInstId='||objectId;
  END IF;

  RETURN hyperlink;
END;
/