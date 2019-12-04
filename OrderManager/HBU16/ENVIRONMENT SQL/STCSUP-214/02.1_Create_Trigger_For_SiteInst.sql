CREATE OR REPLACE TRIGGER upd_siteInst_4_siu_hbu_trig
   BEFORE UPDATE
   ON site_inst
   FOR EACH ROW
DECLARE
     
   new_cclicode       REPORT.STC_SIU_HBU_MSG.CCLICODE%TYPE;
   new_city           REPORT.STC_SIU_HBU_MSG.CITY%TYPE;
   new_citycode       REPORT.STC_SIU_HBU_MSG.CITYCODE%TYPE;
   new_country        REPORT.STC_SIU_HBU_MSG.COUNTRY%TYPE;
   new_district       REPORT.STC_SIU_HBU_MSG.DISTRICT%TYPE;
   new_districtcode   REPORT.STC_SIU_HBU_MSG.DISTRICTCODE%TYPE;
   new_exchangecode   REPORT.STC_SIU_HBU_MSG.EXCHANGECODE%TYPE;
   new_region         REPORT.STC_SIU_HBU_MSG.REGION%TYPE;
   new_siteid         REPORT.STC_SIU_HBU_MSG.SITEID%TYPE;
   new_sitename       REPORT.STC_SIU_HBU_MSG.SITENAME%TYPE;
   new_sitetype       REPORT.STC_SIU_HBU_MSG.SITETYPE%TYPE;
   new_status         REPORT.STC_SIU_HBU_MSG.STATUS%TYPE;
   
BEGIN

   -- only if FIBER and new value for status is IN-SERVICE, the SIU msg is generated
   IF(:NEW.num = 'FIBER' AND :NEW.status = 'IN SERVICE') THEN
      new_cclicode    :=  :NEW.site_hum_id;
      new_city        :=  :NEW.city;
      new_country     :=  :NEW.country;
      new_district    :=  :NEW.county;
      new_region      :=  :NEW.state_prov;
      new_siteid      :=  :NEW.site_hum_id;
      new_sitename    :=  :NEW.clli;
      new_sitetype    :=  :NEW.num;
      new_status      :=  :NEW.status;

      BEGIN
        SELECT attr_value 
          INTO new_citycode
          FROM site_attr_settings sas, val_attr_name van 
         WHERE van.val_attr_inst_id = sas.val_attr_inst_id 
           AND van.attr_name = 'City Code' 
           AND sas.site_inst_id = :NEW.site_inst_id;
      EXCEPTION
        WHEN no_data_found THEN
          new_citycode := NULL;
      END;
      
      BEGIN
      SELECT attr_value 
        INTO new_districtcode
        FROM site_attr_settings sas, val_attr_name van 
       WHERE van.val_attr_inst_id = sas.val_attr_inst_id 
         AND van.attr_name = 'District Code' 
         AND sas.site_inst_id = :NEW.site_inst_id;
      EXCEPTION
        WHEN no_data_found THEN
          new_districtcode := NULL;
      END;

      BEGIN
         SELECT attr_value 
           INTO new_exchangecode
           FROM site_attr_settings sas, val_attr_name van 
          WHERE van.val_attr_inst_id = sas.val_attr_inst_id 
           AND van.attr_name = 'Exchange Code' 
         AND sas.site_inst_id = :NEW.site_inst_id;
      EXCEPTION
        WHEN no_data_found THEN
          new_exchangecode := NULL;
      END;
      
      -- delete the existing records   
      DELETE FROM report.stc_siu_hbu_msg 
       WHERE cclicode = new_cclicode
         AND nvl(city, 'X') = nvl(new_city, 'X')
         AND nvl(citycode, 'X') = nvl(new_citycode, 'X')
         AND nvl(country, 'X') = nvl(new_country, 'X')
         AND nvl(district, 'X') = nvl(new_district, 'X')
         AND nvl(districtcode, 'X') = nvl(new_districtcode, 'X')
         AND nvl(exchangecode, 'X') = nvl(new_exchangecode, 'X')
         AND nvl(region, 'X') = nvl(new_region, 'X')
         AND siteid = new_siteid
         AND nvl(sitename, 'X') = nvl(new_sitename, 'X')
         AND nvl(sitetype, 'X') = nvl(new_sitetype, 'X')
         AND nvl(status, 'X') = nvl(new_status, 'X');
       
      -- insert the new record
      INSERT INTO report.stc_siu_hbu_msg(msgid, cclicode, city, citycode, country, district, districtcode, exchangecode, region, siteid, sitename, sitetype, status)
      SELECT report.stc_siu_hbu_msg_seq.nextval,
             new_cclicode,
             new_city,
             new_citycode,
             new_country,
             new_district,
             new_districtcode,
             new_exchangecode,
             new_region,
             new_siteid,
             new_sitename,
             new_sitetype,
             new_status
        FROM dual;

   END IF;

END;
/