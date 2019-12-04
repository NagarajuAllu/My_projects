CREATE OR REPLACE PROCEDURE assignTokenToNextUserInGroup(groupName IN VARCHAR2, selectedUserId OUT VARCHAR2) IS

  currentCWDocId  stc_roundrobin_mgmt.cwdocid%TYPE;
  selectedCWDocId stc_roundrobin_mgmt.cwdocid%TYPE;

BEGIN

  currentCWDocId  := NULL;
  selectedCWDocId := NULL;

  BEGIN
    -- search current record for the group with token "active"
    SELECT MIN(cwdocid)
      INTO currentCWDocId
      FROM stc_roundrobin_mgmt rr, cwuserrole gnu
     WHERE rr.user_id = gnu.userid
       AND gnu.active = 1
       AND gnu.roleid = groupName
       AND rr.token = 1;
  EXCEPTION
    WHEN no_data_found THEN
      NULL;
  END;

  IF(currentCWDocId IS NULL) THEN
    -- there is no record for the group with token "active"; searching the first one of the group
    BEGIN
      SELECT MIN(cwdocid)
        INTO currentCWDocId
        FROM stc_roundrobin_mgmt rr, cwuserrole gnu
       WHERE rr.user_id = gnu.userid
         AND gnu.active = 1
         AND gnu.roleid = groupName;
    EXCEPTION
      WHEN no_data_found THEN
        selectedCWDocId := NULL;
    END;
  END IF;


  IF(currentCWDocId IS NULL) THEN
    -- do nothing; there is no user active for the group
    NULL;
  ELSE
    BEGIN
      -- starting managing; switching off the "token" for the current user
      UPDATE stc_roundrobin_mgmt
         SET token = 0
       WHERE cwdocid = currentCWDocId;

      -- select next user in the table that belongs to the same group
      SELECT MIN(nu.cwdocid)
        INTO selectedCWDocId
        FROM stc_roundrobin_mgmt nu, cwuserrole gnu
       WHERE nu.user_id = gnu.userid
         AND gnu.active = 1
         AND gnu.roleid = groupName
         AND nu.cwdocid > currentCWDocId;

      IF(selectedCWDocId IS NULL) THEN
        -- it means that there are no other users with CWDOCID higher than the current select,
        -- so wrapping (and selecting the one with min CWDOCID)
        SELECT nu.cwdocid
          INTO selectedCWDocId
          FROM stc_roundrobin_mgmt nu
         WHERE nu.cwdocid = (SELECT MIN(cwdocid)
                               FROM stc_roundrobin_mgmt rr, cwuserrole gnu
                              WHERE rr.user_id = gnu.userid
                                AND gnu.active = 1
                                AND gnu.roleid = groupName);
      END IF;

      UPDATE stc_roundrobin_mgmt
         SET token = 1
       WHERE cwdocid = selectedCWDocId;

    EXCEPTION
      WHEN others THEN
        selectedCWDocId := NULL;
    END;

  END IF;
  
  
  BEGIN
    IF (selectedCWDocId IS NOT NULL) THEN
      SELECT user_id
        INTO selectedUserId
        FROM stc_roundrobin_mgmt
       WHERE cwdocid = selectedCWDocId;
    ELSE
      selectedUserId := NULL;
    END IF;
  EXCEPTION
    WHEN others THEN
      selectedUserId := NULL;
  END;

END;
/