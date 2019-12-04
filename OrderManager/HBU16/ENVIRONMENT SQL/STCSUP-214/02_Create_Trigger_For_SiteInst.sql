CREATE OR REPLACE TRIGGER upd_siteInst_4_siu_hbu_trig
   AFTER UPDATE
   ON site_inst
   FOR EACH ROW

BEGIN

   -- only if FIBER and new value for status is IN-SERVICE, the SIU msg is generated
   IF(:NEW.num = 'FIBER' AND :NEW.status = 'IN SERVICE') THEN
      INSERT INTO report.stc_siu_hbu_msg(msgid, cclicode, city, citycode, country, district, districtcode, exchangecode, region, siteid, sitename, sitetype, status)
      SELECT report.stc_siu_hbu_msg_seq.nextval,
             :NEW.site_hum_id,
             :NEW.city,
             (select attr_value from site_attr_settings sas, val_attr_name van where van.val_attr_inst_id = sas.val_attr_inst_id and van.attr_name = 'City Code' and sas.site_inst_id = :NEW.site_inst_id),
             :NEW.country,
             :NEW.county,
             (select attr_value from site_attr_settings sas, val_attr_name van where van.val_attr_inst_id = sas.val_attr_inst_id and van.attr_name = 'District Code' and sas.site_inst_id = :NEW.site_inst_id),
             (select attr_value from site_attr_settings sas, val_attr_name van where van.val_attr_inst_id = sas.val_attr_inst_id and van.attr_name = 'Exchange Code' and sas.site_inst_id = :NEW.site_inst_id),
             :NEW.state_prov,
             :NEW.site_hum_id,
             :NEW.clli,
             :NEW.num,
             :NEW.status
        FROM dual;

   END IF;

END;
/
