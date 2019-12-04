CREATE TABLE stc_blacklist_service (
  servicenumber VARCHAR2(255) NOT NULL)
TABLESPACE cwe;

ALTER TABLE stc_blacklist_service
  ADD CONSTRAINT pk_stc_blacklist_service primary key (servicenumber)
  USING INDEX
  TABLESPACE cwe_ndx;

prompt Importing table STC_BLACKLIST_SERVICE...
set feedback off
set define off

INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-RIYADH IP3112');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-RIYADH IP3113');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-RIYADH IP3114');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-RIYADH IP3115');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-RIYADH IP3151');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('JEDDAH-JIZAN DIA71');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('JEDDAH-JIZAN DIA73');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('JEDDAH-TAIF DIA42');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('JEDDAH-YENBU DIA23');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-RIYADH IP3314');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-RIYADH IP3315');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-RIYADH IP3331');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-RIYADH IP3335');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('QASSIM-RIYADH DIA287');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('QASSIM-RIYADH DIA288');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('QASSIM-RIYADH DIA289');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('QASSIM-RIYADH DIA290');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('QASSIM-RIYADH DIA294');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-RIYADH DIA2608');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('DAMMAM-RIYADH DIA1087');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('DAMMAM-RIYADH DIA1088');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-RIYADH DIA2740');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-RIYADH DIA2762');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-RIYADHDISTRICTS DIA54');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('NAJRAN-RIYADH DIA74');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-RIYADH DIA2871');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-TABUK DIA153');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-TABUK DIA154');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('HAIL-RIYADH DIA176');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-RIYADH DIA2974');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-RIYADHDISTRICTS DIA57');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('QASSIM-RIYADH DIA333');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('JEDDAH-RIYADH DIA1534');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-RIYADHDIST DIA315');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('ABHA-RIYADH DIA324');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-RIYADH DIA3105');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-YENBU DIA67');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('ALAHSA-RIYADH DIA187');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-RIYADH DIA3187');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('ALAHSA-DAMMAM PLL32');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-RIYADH DIA3246');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-RIYADH DIA3247');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-RIYADH DIA3250');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-YENBU DIA70');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-TAIF DIA105');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('DAMMAM-RIYADH DIA1420');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('ABHA-JEDDAH DIA168');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('ABHA-JEDDAH DIA169');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('ABHA-RIYADH DIA361');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-TAIF DIA108');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('JUBAIL-RIYADH DIA409');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('MAKKAH-RIYADH DIA373');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('MADINAH-YANBU PLL2');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('DAMMAM-DAMMAM PLL143');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-TABUK DIA161');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('QASSIM-RIYADH DIA364');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('HAIL-RIYADH DIA202');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('JEDDAH-RIYADH DIA1713');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-RIYADH DIA3496');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-RIYADH DIA3497');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('JEDDAH-MADINAH DIA228');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-RIYADH DIA3498');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('DAMMAM-RIYADH DIA1529');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('MADINAH-RIYADH DIA230');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('JEDDAH-JIZAN DIA153');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('ABHA-RIYADH DIA375');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('ABHA-RIYADH DIA376');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('QASSIM-RIYADH DIA367');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('QASSIM-RIYADH DIA368');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('QASSIM-RIYADH DIA369');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('JEDDAH-RIYADH DIA1809');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-TAIF DIA122');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('JEDDAH-RIYADH DIA1813');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('JEDDAH-RIYADH DIA1814');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-RIYADH DIA3608');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('MAKKAH-RIYADH DIA399');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('MAKKAH-RIYADH DIA400');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('JEDDAH-RIYADH DIA1840');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-TAIF DIA127');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('MAKKAH-RIYADH DIA419');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('JEDDAH-RIYADH DIA1873');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('JEDDAH-JEDDAH IP1618');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-RIYADH PLL405');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-RIYADH PLL406');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-RIYADH PLL404');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-RIYADH DIA3555');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('ALJOUF-ALJOUF PLL22');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('DAMMAM-RIYADH DIA1317');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('JUBAIL-RIYADH DIA371');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('NAJRAN-RIYADH DIA92');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-RIYADH DIA3177');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-RIYADH IP3281');
INSERT INTO stc_blacklist_service(servicenumber) VALUES ('RIYADH-RIYADH PLL403');

COMMIT;

prompt Done.

set feedback on
set define on
