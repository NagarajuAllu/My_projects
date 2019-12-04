insert into stc_findernvpair_4_gui_config (FINDERLABEL, QUERYSQL, DBLOGICALCONNECTION) values ('Find All BWs in Granite', 'select bw_name from circ_bw where use_in_paths=''Y'' order by 1', 'XNG PRODUCTION [USER:STC_TARGET2]');
insert into stc_findernvpair_4_gui_config (FINDERLABEL, QUERYSQL, DBLOGICALCONNECTION) values ('Find All Circuit Types in Granite', 'select type_name from circ_types where valid_for_path = ''Y'' order by rel_order', 'XNG PRODUCTION [USER:STC_TARGET2]');
insert into stc_findernvpair_4_gui_config (FINDERLABEL, QUERYSQL, DBLOGICALCONNECTION) values ('Find All Interface Types', 'select interfacetype from stc_insertorder_iftype_cfg order by 1', 'ORDER');

commit;


/*****

  FROM HLD

insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('GPS longitude', 1, null, null, 'Text', null, null);
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('GPS latitude', 1, null, null, 'Text', null, null);
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Customer Fax', 0, null, null, 'Text', null, null);
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Customer Bareed Saudi Number', 0, null, null, 'Text', null, null);
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Customer WebSite', 0, null, null, 'Text', null, null);
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Customer Service Requester Name', 0, null, null, 'Text', null, null);
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Customer Service Requester Telephone Number', 0, null, null, 'Text', null, null);
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Customer Service Requester email', 0, null, null, 'Text', null, null);
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Customer Contact -  Telecom Engineer - Name', 0, null, null, 'Text', null, null);
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Customer Contact -  Telecom Engineer – Telephone Number', 0, null, null, 'Text', null, null);
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Customer Contact -  Telecom Engineer – Mobile Number', 0, null, null, 'Text', null, null);
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Customer Contact - Building Access Facilitator - Name', 0, null, null, 'Text', null, null);
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Customer Contact - Building Access Facilitator – Telephone Number', 0, null, null, 'Text', null, null);
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Customer Contact - Building Access Facilitator – Mobile Number', 0, null, null, 'Text', null, null);
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Customer Contact - Building Manager - Name', 0, null, null, 'Text', null, null);
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Customer Contact - Building Manager – Telephone Number', 0, null, null, 'Text', null, null);
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Customer Contact - Building Manager – Mobile Number', 0, null, null, 'Text', null, null);
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Customer Working Hours', 0, null, null, 'Text', null, null);
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Allowed to work on weekends?', 0, null, null, 'LoV', 'Yes;No', null);
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Communication Room – Location', 0, null, null, 'LoV', 'Building;Industrial Compound;Others No', null);
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Communication Room – Gate', 0, null, null, 'Text', null, null);
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Communication Room – Floor', 0, null, null, 'Text', null, null);
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Communication Room – Wing', 0, null, null, 'Text', null, null);
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Communication Room – Address', 0, null, null, 'Text', null, null);
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Communication Room – Site/Telecom room readiness/GPS', 0, null, null, 'Text', null, null);
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Plate ID/site number', 0, null, null, 'Text', null, null);
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Requires Access Permission', 0, null, null, 'Text', null, null);
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Remarks/comments', 0, null, null, 'Text', null, null);
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Service 1 – Bandwidth', 0, null, null, 'Finder', null, 'Find All BWs in Granite');
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Service - 1 - Type', 0, null, null, 'Finder', null, 'Find All Circuit Types in Granite');
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Service - 1 – Interface Type', 0, null, null, 'Finder', null, 'Find All Interface Types');
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Service 2 – Bandwidth', 0, null, null, 'Finder', null, 'Find All BWs in Granite');
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Service - 2 - Type', 0, null, null, 'Finder', null, 'Find All Circuit Types in Granite');
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Service - 2 – Interface Type', 0, null, null, 'Finder', null, 'Find All Interface Types');
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Service 3 – Bandwidth', 0, null, null, 'Finder', null, 'Find All BWs in Granite');
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Service - 3 - Type', 0, null, null, 'Finder', null, 'Find All Circuit Types in Granite');
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Service - 3 – Interface Type', 0, null, null, 'Finder', null, 'Find All Interface Types');
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Service 4 – Bandwidth', 0, null, null, 'Finder', null, 'Find All BWs in Granite');
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Service - 4 - Type', 0, null, null, 'Finder', null, 'Find All Circuit Types in Granite');
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Service - 4 – Interface Type', 0, null, null, 'Finder', null, 'Find All Interface Types');
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Service 5 – Bandwidth', 0, null, null, 'Finder', null, 'Find All BWs in Granite');
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Service - 5 - Type', 0, null, null, 'Finder', null, 'Find All Circuit Types in Granite');
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Service - 5 – Interface Type', 0, null, null, 'Finder', null, 'Find All Interface Types');
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Description', 0, null, null, 'Text', null, null);
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Held Order Check', 0, null, null, 'LoV', 'Yes;No', null);
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Order id', 0, 'Held Order Check', 'Yes', 'Text', null, null);
insert into stc_nvpair_4_gui_config (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values ('Circuit Name', 0, 'Held Order Check', 'Yes', 'Text', null, null);

*****/

-- ADDED IN PT
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Account Manager Email', 0, null, null, 'Text', null, null);
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Account Manager Name', 0, null, null, 'Text', null, null);
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Account Manager Phone', 0, null, null, 'Text', null, null);
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Allowed to work on weekends', 0, null, null, 'LoV', 'Yes;No', null);
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Attachment', 0, null, null, 'Text', null, null);
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Bareed Saudi Number', 0, null, null, 'Text', null, null);
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Comments', 0, null, null, 'Text', null, null);
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Communication Room - Address', 0, null, null, 'Text', null, null);
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Communication Room - Floor', 0, null, null, 'Text', null, null);
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Communication Room - Gate', 0, null, null, 'Text', null, null);
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Communication Room - Location', 0, null, null, 'LoV', 'Building;Industrial Compound;Other', null);
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Communication Room - Site/Telecom Readiness/GPS', 0, null, null, 'Text', null, null);
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Communication Room - Wing', 0, null, null, 'Text', null, null);
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Customer Contact - Service Requester Email', 0, null, null, 'Text', null, null);
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Customer Contact - Service Requester Name', 1, null, null, 'Text', null, null);
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Customer Contact - Service Requester Number', 1, null, null, 'Text', null, null);
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Customer Contact - Telecom Engineer - Mobile', 0, null, null, 'Text', null, null);
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Customer Contact - Telecom Engineer - Name', 0, null, null, 'Text', null, null);
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Customer Contact - Telecom Engineer - Phone', 0, null, null, 'Text', null, null);
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Customer Name', 1, null, null, 'Text', null, null);
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Customer Working Hours', 0, null, null, 'Text', null, null);
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Existing Telecom Facilities', 0, null, null, 'Text', null, null);
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('GPS Latitude', 0, null, null, 'Text', null, null);
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('GPS Longitude', 1, null, null, 'Text', null, null);
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Plate ID/Site Number', 1, null, null, 'Text', null, null);
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Priority', 0, null, null, 'LoV', 'Low;Medium;High', null);
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Requires Access Permission', 0, null, null, 'LoV', 'Yes;No', null);
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Service - 1 - BW', 0, null, null, 'Finder', null, 'Find All BWs in Granite');
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Service - 1 - Interface', 0, null, null, 'Finder', null, 'Find All Interface Types');
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Service - 1 - Type', 0, null, null, 'Finder', null, 'Find All Circuit Types in Granite');
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Service - 2 - BW', 0, null, null, 'Finder', null, 'Find All BWs in Granite');
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Service - 2 - Interface', 0, null, null, 'Finder', null, 'Find All Interface Types');
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Service - 2 - Type', 0, null, null, 'Finder', null, 'Find All Circuit Types in Granite');
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Service - 3 - BW', 0, null, null, 'Finder', null, 'Find All BWs in Granite');
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Service - 3 - Interface', 0, null, null, 'Finder', null, 'Find All Interface Types');
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Service - 3 - Type', 0, null, null, 'Finder', null, 'Find All Circuit Types in Granite');
insert into STC_NVPAIR_4_GUI_CONFIG (NAME, MANDATORY, MANDATORY_ON, MANDATORY_ON_VALUE, VALUE_TYPE, VALUES_FOR_LOV, FINDER_NAME) values('Technology', 0, null, null, 'LoV', 'Fiber;Copper;Microwave;VSAT;Other', null);

commit;


insert into STC_INSERTORDER_REASONCODE_CFG (CWDOCID, REASONCODE) values ('1', 'IFO');


insert into STC_INSERTORDER_IFTYPE_CFG (INTERFACETYPE) values ('COPPER');
insert into STC_INSERTORDER_IFTYPE_CFG (INTERFACETYPE) values ('ETHERNET');
insert into STC_INSERTORDER_IFTYPE_CFG (INTERFACETYPE) values ('FIBER');
insert into STC_INSERTORDER_IFTYPE_CFG (INTERFACETYPE) values ('WIRELESS');
insert into STC_INSERTORDER_IFTYPE_CFG (INTERFACETYPE) values ('XDSL');

commit;
