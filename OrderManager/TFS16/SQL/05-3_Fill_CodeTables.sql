prompt Filling table STC_PICKLIST...


create or replace FUNCTION INSERT_TRANSTXT (transTx IN VARCHAR2)
	RETURN VARCHAR2
IS
  	v_id VARCHAR2(10);
    trans_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO trans_count FROM cwtranslations where translation = transTx and language = 'en-xx' AND ROWNUM = 1;
  if trans_count < 1 then
    INSERT INTO cwtranslations (id, language, lastupdateddate, translation)
	VALUES (CWTRANSLATIONSEQ.NEXTVAL, 'en-xx', TO_DATE(SYSDATE), NVL(transTx, '-'))
	returning id into v_id;
		
	--INSERT INTO cwtranslations (id, language, lastupdateddate, translation)
	--VALUES (CWTRANSLATIONSEQ.CURRVAL, 'en-ca', TO_DATE(SYSDATE), NVL(transTx, '-'));
  else
    select id into v_id from cwtranslations where translation = transTx AND ROWNUM = 1;
  end if;
  RETURN v_id;
END;
/

-- create code table
create or replace PROCEDURE codeTable_create (codeTableName IN VARCHAR2, DESCRIPTION IN VARCHAR2)
AS
BEGIN
	DELETE FROM CWDBCODETABLES WHERE CTTYPE = '-cwfCodeTableIndex' AND CODE = codeTableName;
	DELETE FROM CWDBCODETABLES WHERE CTTYPE = codeTableName;
	INSERT INTO CWDBCODETABLES (CTTYPE, CODE, ACTIVE, DESCRIPTION, PARAM, UPDATEDBY, LASTUPDATEDDATE)
VALUES ('-cwfCodeTableIndex', codeTableName, 1, INSERT_TRANSTXT(DESCRIPTION), null, 'upadmin', sysdate);
END;
/

-- create codes in code table
create or replace PROCEDURE code_create (codeTableName IN VARCHAR2, code IN VARCHAR2, description IN VARCHAR2)
AS
BEGIN
	INSERT INTO CWDBCODETABLES (CTTYPE, CODE, ACTIVE, DESCRIPTION, PARAM, UPDATEDBY, LASTUPDATEDDATE)
VALUES (codeTableName, code, 1, INSERT_TRANSTXT(description), null, 'upadmin', sysdate);
END;
/

set define off;


call codeTable_create ('AREA_REGION', 'AREA_REGION');
call code_create ('AREA_REGION', 'Remote Site', 'Remote Site');
call code_create ('AREA_REGION', 'Riyadh/Jeddah Site', 'Riyadh/Jeddah Site');

call codeTable_create ('BusinessOwner', 'BusinessOwner');
call code_create ('BusinessOwner', 'CNI', 'CNI');
call code_create ('BusinessOwner', 'EBU', 'EBU');
call code_create ('BusinessOwner', 'FNI', 'FNI');
call code_create ('BusinessOwner', 'PID', 'PID');
call code_create ('BusinessOwner', 'WHOLESALE', 'WHOLESALE');
call code_create ('BusinessOwner', 'WNI', 'WNI');

call codeTable_create ('CWO Type', 'CWO Type');
call code_create ('CWO Type', 'CWO Type Value', 'CWO Type Value');

call codeTable_create ('Category', 'Category');
call code_create ('Category', 'Card', 'Card');
call code_create ('Category', 'HOST MOP', 'HOST MOP');
call code_create ('Category', 'HOST MUX', 'HOST MUX');
call code_create ('Category', 'Link', 'Link');
call code_create ('Category', 'Link Migration', 'Link Migration');
call code_create ('Category', 'Link MPLS', 'Link MPLS');
call code_create ('Category', 'Migration', 'Migration');
call code_create ('Category', 'Misc', 'Misc');
call code_create ('Category', 'MOP', 'MOP');
call code_create ('Category', 'MSAN MOP', 'MSAN MOP');
call code_create ('Category', 'MSAN MUX', 'MSAN MUX');
call code_create ('Category', 'Mux', 'Mux');
call code_create ('Category', 'Ring', 'Ring');
call code_create ('Category', 'Tie Cable', 'Tie Cable');

call codeTable_create ('BI Code', 'BI Code');
call code_create ('BI Code', 'Alternate-MPLS Route', 'Alternate-MPLS Route');
call code_create ('BI Code', 'Alternate-Transmission Route', 'Alternate-Transmission Route');
call code_create ('BI Code', 'Awaiting for circuit migration', 'Awaiting for circuit migration');
call code_create ('BI Code', 'Awaiting migration', 'Awaiting migration');
call code_create ('BI Code', 'Low Order X-C is already full', 'Low Order X-C is already full');
call code_create ('BI Code', 'No Available 10GE Port', 'No Available 10GE Port');
call code_create ('BI Code', 'No available 2Mbps DDF', 'No available 2Mbps DDF for E1 termination');
call code_create ('BI Code', 'No available 2Mbps port', 'No available 2Mbps port');
call code_create ('BI Code', 'No available 34Mbps port', 'No available 34Mbps port');
call code_create ('BI Code', 'No available add/drop node', 'No available add/drop node');
call code_create ('BI Code', 'No available approved MOP MSAN', 'No available approved MOP for MSAN');
call code_create ('BI Code', 'No available approved MOP RAN', 'No available approved MOP for RAN');
call code_create ('BI Code', 'No available DACS port', 'No available DACS port');
call code_create ('BI Code', 'No available DWDM link', 'No available DWDM link');
call code_create ('BI Code', 'No available DWDM port', 'No available DWDM port');
call code_create ('BI Code', 'No available Fast Ethernet port', 'No available Fast Ethernet port');
call code_create ('BI Code', 'No available GBE port', 'No available GBE port');
call code_create ('BI Code', 'No available grooming equipment', 'No available grooming equipment');
call code_create ('BI Code', 'No available L2-DWDM link', 'No available L2-DWDM link');
call code_create ('BI Code', 'No available SFP I/F module', 'No available SFP interface module');
call code_create ('BI Code', 'No available STM16 port', 'No available STM16 port');
call code_create ('BI Code', 'No available STM1e port', 'No available STM1e port');
call code_create ('BI Code', 'No available STM1o port', 'No available STM1o port');
call code_create ('BI Code', 'No available STM4 port', 'No available STM4 port');
call code_create ('BI Code', 'No available STM64 port connect.', 'No available STM64 port connection');
call code_create ('BI Code', 'No avail STM-N ports cross-over', 'No available STM-N ports for cross-over');
call code_create ('BI Code', 'No Electrical Tie Cable', 'No Electrical Tie Cable');
call code_create ('BI Code', 'No low-order crossconnect board', 'No low-order crossconnect board');
call code_create ('BI Code', 'No more AU4 slot available', 'No more AU4 slot available');
call code_create ('BI Code', 'No more available timeslot', 'No more available timeslot');
call code_create ('BI Code', 'No Optical Tie Cable', 'No Optical Tie Cable');
call code_create ('BI Code', 'No tie cable', 'No tie cable');
call code_create ('BI Code', 'Not Specified', 'Not Specified');
call code_create ('BI Code', 'Port has no ODF/DDF Termination', 'Port has no ODF/DDF Termination');
call code_create ('BI Code', 'Protection card', 'Protection card');
call code_create ('BI Code', 'Ring not yet available', 'Ring not yet available');
call code_create ('BI Code', 'Routing is uncomplete / wrong', 'Routing is uncomplete / wrong');

call codeTable_create ('Contractor', 'Contractor');
call code_create ('Contractor', 'Alcatel', 'Alcatel');
call code_create ('Contractor', 'Ericsson', 'Ericsson');
call code_create ('Contractor', 'Huawei', 'Huawei');
call code_create ('Contractor', 'Lucent', 'Lucent');
call code_create ('Contractor', 'ModSquad', 'ModSquad');
call code_create ('Contractor', 'Nera', 'Nera');
call code_create ('Contractor', 'Siemens', 'Siemens');
call code_create ('Contractor', 'Unknown', 'Unknown');

call codeTable_create ('Customer Project Phase', 'Customer Project Phase');
call code_create ('Customer Project Phase', 'IPTV', 'IPTV');
call code_create ('Customer Project Phase', 'NEMO', 'NEMO');

call codeTable_create ('Customer Project', 'Customer Project');
call code_create ('Customer Project', 'IPTV', 'IPTV');

call codeTable_create ('Customer', 'Customer');
call code_create ('Customer', '-PSC', '-PSC');
call code_create ('Customer', '907 Customer Care.', '907 Customer Care.');
call code_create ('Customer', 'ADSL', 'ADSL');
call code_create ('Customer', 'ALJAWAL', 'ALJAWAL');
call code_create ('Customer', 'ALJAWAL-CORE', 'ALJAWAL-CORE');
call code_create ('Customer', 'Audio Text', 'Audio Text');
call code_create ('Customer', 'BRAVO', 'BRAVO');
call code_create ('Customer', 'Bayanat Co.', 'Bayanat Co.');
call code_create ('Customer', 'COM IS', 'COM IS');
call code_create ('Customer', 'COMIS', 'COMIS');
call code_create ('Customer', 'Customer Care.', 'Customer Care.');
call code_create ('Customer', 'Customer2', 'Customer2');
call code_create ('Customer', 'DATA TRANSPORT', 'DATA TRANSPORT');
call code_create ('Customer', 'DWDM (NMS)', 'DWDM (NMS)');
call code_create ('Customer', 'EBU', 'EBU');
call code_create ('Customer', 'IDEN', 'IDEN');
call code_create ('Customer', 'IDS', 'IDS');
call code_create ('Customer', 'IGW SaudiNet', 'IGW SaudiNet');
call code_create ('Customer', 'IMA Expansion in C.O', 'IMA Expansion in C.O');
call code_create ('Customer', 'MSAN (ADSL)', 'MSAN (ADSL)');
call code_create ('Customer', 'Mohammed  Al - Mulhem', 'Mohammed  Al - Mulhem');
call code_create ('Customer', 'NGN Core', 'NGN Core');
call code_create ('Customer', 'O&M', 'O&M');
call code_create ('Customer', 'RAN(ADSL)', 'RAN(ADSL)');
call code_create ('Customer', 'RAN(DLL)', 'RAN(DLL)');
call code_create ('Customer', 'RAN(POTS)', 'RAN(POTS)');
call code_create ('Customer', 'RAN(POTS/ADSL)', 'RAN(POTS/ADSL)');
call code_create ('Customer', 'RAN(PSTN)', 'RAN(PSTN)');
call code_create ('Customer', 'Saudi Aramco', 'Saudi Aramco');
call code_create ('Customer', 'Siemens RAN DSL & TX Expansion', 'Siemens RAN DSL & TX Expansion project-2007');
call code_create ('Customer', 'Teletraffic', 'Teletraffic');
call code_create ('Customer', 'Wholesale', 'Wholesale');
call code_create ('Customer', 'ZABA925', 'ZABA925');
call code_create ('Customer', 'ashraf rahamnah', 'ashraf rahamnah');

call codeTable_create ('FA Rejection Code', 'FA Rejection Code');
call code_create ('FA Rejection Code', 'Customer Equipment installed', 'Customer Equipment installed / Ready');
call code_create ('FA Rejection Code', 'CWO needs Tie Cable', 'CWO needs Tie Cable');
call code_create ('FA Rejection Code', 'Gate Pass provided', 'Gate Pass provided');
call code_create ('FA Rejection Code', 'Need Jumpering', 'Need Jumpering');
call code_create ('FA Rejection Code', 'Need VLAN', 'Need VLAN');
call code_create ('FA Rejection Code', 'No label @ Tx DDF (or not found)', 'No label @ Tx DDF (or not found)');
call code_create ('FA Rejection Code', 'Trunk SW Activation', 'Trunk SW Activation');
call code_create ('FA Rejection Code', 'Tx DDF occupied', 'Tx DDF occupied');

call codeTable_create ('Forward To Department', 'Forward To Department');
call code_create ('Forward To Department', 'Access Solution', 'Access Solution');
call code_create ('Forward To Department', 'Access Transport', 'Access Transport');
call code_create ('Forward To Department', 'Backbone Transmission', 'Backbone Transmission');
call code_create ('Forward To Department', 'CIRCUIT DESIGN', 'CIRCUIT DESIGN');
call code_create ('Forward To Department', 'Data Network', 'Data Network');
call code_create ('Forward To Department', 'FA-Tx', 'FA-Tx');
call code_create ('Forward To Department', 'FNI (C/E)', 'FNI (C/E)');
call code_create ('Forward To Department', 'FNI (W/S)', 'FNI (W/S)');
call code_create ('Forward To Department', 'INSTALLATION', 'INSTALLATION');
call code_create ('Forward To Department', 'Migration Team', 'Migration Team');
call code_create ('Forward To Department', 'MOD SQUAD', 'MOD SQUAD');
call code_create ('Forward To Department', 'NEMO', 'NEMO');
call code_create ('Forward To Department', 'Planning', 'Planning');
call code_create ('Forward To Department', 'WNI', 'WNI');

call codeTable_create ('Hajj Committment', 'Hajj Committment');
call code_create ('Hajj Committment', 'Hajj Committment Value', 'Hajj Committment Value');

call codeTable_create ('Issue PRN', 'Issue PRN');
call code_create ('Issue PRN', 'Issue PRN Value', 'Issue PRN Value');

call codeTable_create ('MoP Impl Status', 'MoP Impl Status');
call code_create ('MoP Impl Status', 'In Progress', 'In Progress');
call code_create ('MoP Impl Status', 'Issued', 'Issued');
call code_create ('MoP Impl Status', 'Not Issued', 'Not Issued');

call codeTable_create ('MoP Status', 'MoP Status');
call code_create ('MoP Status', 'In Progress', 'In Progress');
call code_create ('MoP Status', 'Issued', 'Issued');
call code_create ('MoP Status', 'Not Issued', 'Not Issued');

call codeTable_create ('Network Type', 'Network Type');
call code_create ('Network Type', 'Access', 'Access');
call code_create ('Network Type', 'DWDM', 'DWDM');
call code_create ('Network Type', 'JN', 'JN');

call codeTable_create ('Network Type', 'Network Type');
call code_create ('Network Type', 'Access', 'Access');
call code_create ('Network Type', 'DWDM', 'DWDM');
call code_create ('Network Type', 'JN', 'JN');
call code_create ('Network Type', 'LD', 'LD');

call codeTable_create ('Pending Reason', 'Pending Reason');
call code_create ('Pending Reason', 'Pending Reason Value', 'Pending Reason Value');

call codeTable_create ('Plan Type', 'Plan Type');
call code_create ('Plan Type', 'Plan Type Value', 'Plan Type Value');

call codeTable_create ('Project', 'Project');
call code_create ('Project', '190K Retirement', '190K Retirement');
call code_create ('Project', '25K DSL', '25K DSL');
call code_create ('Project', '450K', '450K');
call code_create ('Project', '450K DLL', '450K DLL');
call code_create ('Project', '450kPHII', '450kPHII');
call code_create ('Project', '92 RAN Replacement', '92 RAN Replacement');
call code_create ('Project', 'ACCulink', 'ACCulink');
call code_create ('Project', 'ADM16 MIGRATION', 'ADM16 MIGRATION');
call code_create ('Project', 'ADSL 450k', 'ADSL 450k');
call code_create ('Project', 'Al-waseet', 'Al-waseet');
call code_create ('Project', 'Anymedia', 'Anymedia');
call code_create ('Project', 'Anymedia 21k', 'Anymedia 21k');
call code_create ('Project', 'ATM 2005', 'ATM 2005');
call code_create ('Project', 'ATM 2006', 'ATM 2006');
call code_create ('Project', 'ATM Optimization', 'ATM Optimization');
call code_create ('Project', 'Bildats', 'Bildats');
call code_create ('Project', 'C&I PH4', 'C&I PH4');
call code_create ('Project', 'C&I PH5', 'C&I PH5');
call code_create ('Project', 'C&I PH6', 'C&I PH6');
call code_create ('Project', 'C7 Enhancement', 'C7 Enhancement');
call code_create ('Project', 'C7Diversity', 'C7Diversity');
call code_create ('Project', 'Card Swapping(450k)', 'Card Swapping(450k)');
call code_create ('Project', 'CDMA PH-1', 'CDMA PH-1');
call code_create ('Project', 'CDMA PH2', 'CDMA PH2');
call code_create ('Project', 'Circuit Reconfiguration', 'Circuit Reconfiguration');
call code_create ('Project', 'Clean-up Paging', 'Clean-up Paging');
call code_create ('Project', 'Clean-up SN-GSM', 'Clean-up SN-GSM');
call code_create ('Project', 'Core VOIP enablement', 'Core VOIP enablement');
call code_create ('Project', 'DIAL-UP MIGRATION', 'DIAL-UP MIGRATION');
call code_create ('Project', 'DNR', 'DNR');
call code_create ('Project', 'DXX-Migration', 'DXX-Migration');
call code_create ('Project', 'Emergency Plan 2003', 'Emergency Plan 2003');
call code_create ('Project', 'Ethernet', 'Ethernet');
call code_create ('Project', 'GSM', 'GSM');
call code_create ('Project', 'GSM HAJJ1427', 'GSM HAJJ1427');
call code_create ('Project', 'GSM RAMADAN 1427', 'GSM RAMADAN 1427');
call code_create ('Project', 'GSM Ramadan 1428', 'GSM Ramadan 1428');
call code_create ('Project', 'GSME4', 'GSME4');
call code_create ('Project', 'GSME5', 'GSME5');
call code_create ('Project', 'GSME6', 'GSME6');
call code_create ('Project', 'GSME6-PO2', 'GSME6-PO2');
call code_create ('Project', 'GSME6-PO4', 'GSME6-PO4');
call code_create ('Project', 'GSME7', 'GSME7');
call code_create ('Project', 'GSS1', 'GSS1');
call code_create ('Project', 'ICMS WAVE1', 'ICMS WAVE1');
call code_create ('Project', 'ICMS WAVE2', 'ICMS WAVE2');
call code_create ('Project', 'ICMS WAVE3', 'ICMS WAVE3');
call code_create ('Project', 'ICMS WAVE4', 'ICMS WAVE4');
call code_create ('Project', 'IMA EXP. 2007', 'IMA EXP. 2007');
call code_create ('Project', 'Implementation', 'Implementation');
call code_create ('Project', 'INTERNET NCR 2005', 'INTERNET NCR 2005');
call code_create ('Project', 'INTERNET NCR 2006', 'INTERNET NCR 2006');
call code_create ('Project', 'INT-PH1', 'INT-PH1');
call code_create ('Project', 'INT-PH2', 'INT-PH2');
call code_create ('Project', 'INT-PH3', 'INT-PH3');
call code_create ('Project', 'IP4', 'IP4');
call code_create ('Project', 'IP-MPLS', 'IP-MPLS');
call code_create ('Project', 'ITC PH1', 'ITC PH1');
call code_create ('Project', 'KAEP03-NT', 'KAEP03-NT');
call code_create ('Project', 'MISC.', 'MISC.');
call code_create ('Project', 'MMS', 'MMS');
call code_create ('Project', 'MODA', 'MODA');
call code_create ('Project', 'MODA-RAN', 'MODA-RAN');
call code_create ('Project', 'MOI', 'MOI');
call code_create ('Project', 'MSTP-DXX', 'MSTP-DXX');
call code_create ('Project', 'NAS EXP.2006', 'NAS EXP.2006');
call code_create ('Project', 'Optimization', 'Optimization');
call code_create ('Project', 'PA', 'PA');
call code_create ('Project', 'PO2 GSME5', 'PO2 GSME5');
call code_create ('Project', 'PPC 2004', 'PPC 2004');
call code_create ('Project', 'PPC Plan', 'PPC Plan');
call code_create ('Project', 'PPC Reconfiguration', 'PPC Reconfiguration');
call code_create ('Project', 'PPC-II', 'PPC-II');
call code_create ('Project', 'PRX', 'PRX');
call code_create ('Project', 'PRX / Y2K', 'PRX / Y2K');
call code_create ('Project', 'RAM1420', 'RAM1420');
call code_create ('Project', 'Ramadan 1429 MSC', 'Ramadan 1429 MSC');
call code_create ('Project', 'SDH-TE Migration', 'SDH-TE Migration');
call code_create ('Project', 'Siemens MOI', 'Siemens MOI');
call code_create ('Project', 'Special Services', 'Special Services');
call code_create ('Project', 'SRS', 'SRS');
call code_create ('Project', 'SS7-MAS', 'SS7-MAS');
call code_create ('Project', 'STC TEST LAB.', 'STC TEST LAB.');
call code_create ('Project', 'STM1 backbone', 'STM1 backbone');
call code_create ('Project', 'Summer Plan 2004', 'Summer Plan 2004');
call code_create ('Project', 'SUMMER PLAN 2005', 'SUMMER PLAN 2005');
call code_create ('Project', 'SUMMER PLAN 2006', 'SUMMER PLAN 2006');
call code_create ('Project', 'TEP3', 'TEP3');
call code_create ('Project', 'TEP6', 'TEP6');
call code_create ('Project', 'TEP7', 'TEP7');
call code_create ('Project', 'TEP7/EWSD', 'TEP7/EWSD');
call code_create ('Project', 'TEST', 'TEST');
call code_create ('Project', 'U.I.N Expansion', 'U.I.N Expansion');
call code_create ('Project', 'U.I.N.', 'U.I.N.');
call code_create ('Project', 'UPGRADE TO SN', 'UPGRADE TO SN');
call code_create ('Project', 'URP', 'URP');
call code_create ('Project', 'Y2K', 'Y2K');
call code_create ('Project', 'ZMKA080 Retirement', 'ZMKA080 Retirement');

call codeTable_create ('Protection Type', 'Protection Type');
call code_create ('Protection Type', 'Protection Type Value', 'Protection Type Value');

call codeTable_create ('Reason For Issue', 'Reason For Issue');
call code_create ('Reason For Issue', 'Reason For Issue Value', 'Reason For Issue Value');

call codeTable_create ('Request Type', 'Request Type');
call code_create ('Request Type', 'Request Type Value', 'Request Type Value');

call codeTable_create ('Requirement Type', 'Requirement Type');
call code_create ('Requirement Type', '2E3', '2E3');
call code_create ('Requirement Type', 'DS3', 'DS3');
call code_create ('Requirement Type', 'E1 Channelized', 'E1 Channelized');
call code_create ('Requirement Type', 'GE Optical', 'GE Optical');
call code_create ('Requirement Type', 'STM1-e', 'STM1-e');
call code_create ('Requirement Type', 'STM1-o', 'STM1-o');

call codeTable_create ('SDH Category', 'SDH Category');
call code_create ('SDH Category', 'Card Insertion', 'Card Insertion');
call code_create ('SDH Category', 'Delivery Only', 'Delivery Only');
call code_create ('SDH Category', 'Dismantling', 'Dismantling');
call code_create ('SDH Category', 'E1 Extraction', 'E1 Extraction');

call codeTable_create ('Secondary Owner', 'Secondary Owner');
call code_create ('Secondary Owner', 'Access Transport', 'Access Transport');
call code_create ('Secondary Owner', 'CNI', 'CNI');
call code_create ('Secondary Owner', 'FA', 'FA');
call code_create ('Secondary Owner', 'FNI', 'FNI');
call code_create ('Secondary Owner', 'ISP design', 'ISP design');
call code_create ('Secondary Owner', 'Mapping', 'Mapping');
call code_create ('Secondary Owner', 'ModSquad', 'ModSquad');
call code_create ('Secondary Owner', 'OSP Design', 'OSP Design');
call code_create ('Secondary Owner', 'OSP Planning', 'OSP Planning');
call code_create ('Secondary Owner', 'PCC', 'PCC');
call code_create ('Secondary Owner', 'PID-ISOW', 'PID-ISOW');
call code_create ('Secondary Owner', 'TX-Design', 'TX-Design');
call code_create ('Secondary Owner', 'WNI', 'WNI');

call codeTable_create ('Service Type', 'Service Type');
call code_create ('Service Type', 'Service Type Value', 'Service Type Value');

call codeTable_create ('Site Exchange Type', 'Site Exchange Type');
call code_create ('Site Exchange Type', 'Site Exchange Type Value1', 'Site Exchange Type Value1');
call code_create ('Site Exchange Type', 'Site Exchange Type Value2', 'Site Exchange Type Value2');

call codeTable_create ('Site Interface', 'Site Interface');
call code_create ('Site Interface', 'FE', 'FE');
call code_create ('Site Interface', 'FEo/e', 'FEo/e');

call codeTable_create ('Site JV Code', 'Site JV Code');
call code_create ('Site JV Code', 'Site JV Code Value1', 'Site JV Code Value1');
call code_create ('Site JV Code', 'Site JV Code Value2', 'Site JV Code Value2');

call codeTable_create ('SoW Status', 'SoW Status');
call code_create ('SoW Status', 'In Progress', 'In Progress');
call code_create ('SoW Status', 'Issued', 'Issued');

call codeTable_create ('Structure Type', 'Structure Type');
call code_create ('Structure Type', 'Structure Type Value', 'Structure Type Value');

call codeTable_create ('Switch Type', 'Switch Type');
call code_create ('Switch Type', 'Switch Type Value', 'Switch Type Value');

call codeTable_create ('TFR Mapping Status', 'TFR Mapping Status');
call code_create ('TFR Mapping Status', 'TFR Mapping Status Value', 'TFR Mapping Status Value');

call codeTable_create ('TFR Rejection Code', 'TFR Rejection Code');
call code_create ('TFR Rejection Code', 'Customer Equipment installed', 'Customer Equipment installed / Ready');
call code_create ('TFR Rejection Code', 'CWO needs Tie Cable', 'CWO needs Tie Cable');
call code_create ('TFR Rejection Code', 'Gate Pass provided', 'Gate Pass provided');
call code_create ('TFR Rejection Code', 'Need Jumpering', 'Need Jumpering');
call code_create ('TFR Rejection Code', 'Need VLAN', 'Need VLAN');
call code_create ('TFR Rejection Code', 'No label @ Tx DDF (or not found)', 'No label @ Tx DDF (or not found)');
call code_create ('TFR Rejection Code', 'Trunk SW Activation', 'Trunk SW Activation');
call code_create ('TFR Rejection Code', 'Tx DDF occupied', 'Tx DDF occupied');

call codeTable_create ('TFR Remarks', 'TFR Remarks');
call code_create ('TFR Remarks', 'TFR Remarks Value', 'TFR Remarks Value');

call codeTable_create ('TFR Type', 'TFR Type');
call code_create ('TFR Type', 'TFR Type Value', 'TFR Type Value');

call codeTable_create ('Tech Type', 'Tech Type');
call code_create ('Tech Type', 'Tech Type Value', 'Tech Type Value');

call codeTable_create ('Traffic Diversity', 'Traffic Diversity');
call code_create ('Traffic Diversity', 'DIVERSITY', 'DIVERSITY');
call code_create ('Traffic Diversity', 'NO DIVERSITY', 'NO DIVERSITY');

call codeTable_create ('Traffic Type', 'Traffic Type');
call code_create ('Traffic Type', 'Traffic Type Value', 'Traffic Type Value');

call codeTable_create ('Network Status', 'Network Status');
call code_create ('Network Status', 'COMPLETED', 'COMPLETED');
call code_create ('Network Status', 'IN PROGRESS', 'IN PROGRESS');
call code_create ('Network Status', 'PENDING', 'PENDING');

commit;


set define on;