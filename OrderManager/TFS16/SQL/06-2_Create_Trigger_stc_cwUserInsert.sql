prompt Creating new trigger stc_cwUserInsert

CREATE OR REPLACE TRIGGER stc_cwUserInsert BEFORE INSERT ON cwUser FOR EACH ROW
DECLARE

  newCwDocId stc_roundrobin_mgmt.cwdocid%TYPE;

BEGIN

  SELECT TO_CHAR(MAX(TO_NUMBER(cwdocid)) + 1) 
    INTO newCwDocId
    FROM stc_roundrobin_mgmt;

  INSERT INTO stc_roundrobin_mgmt (cwdocid, user_id, token)
  VALUES (newCwDocId, :new.USERID, 0);

END;
/