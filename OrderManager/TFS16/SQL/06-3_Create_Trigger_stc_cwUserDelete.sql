prompt Creating new trigger stc_cwUserDelete

CREATE OR REPLACE TRIGGER stc_cwUserDelete BEFORE DELETE ON cwUser FOR EACH ROW
DECLARE

  
BEGIN

  DELETE FROM stc_roundrobin_mgmt WHERE user_id = :new.USERID;

END;
/