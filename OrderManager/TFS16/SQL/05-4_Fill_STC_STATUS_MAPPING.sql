prompt Filling table STC_STATUS_MAPPING...

-- PRNR --
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('1', 'PRNR', 'NEW', 'NEW');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('2', 'PRNR', 'ACCEPTED', 'ACCEPTED');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('3', 'PRNR', 'REJECTED', 'REJECTED');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('4', 'PRNR', 'CANCELLED', 'CANCELLED');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('5', 'PRNR', 'REVISED','REVISED');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('6', 'PRNR', 'COMPLETED', 'COMPLETED');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('53', 'PRNR', 'AUTOMATICALLY ACCEPTED', 'AUTOMATICALLY ACCEPTED');

-- PRN --
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('7', 'PRN', 'NEW', 'NEW');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('8', 'PRN', 'RESERVATION CANCELLED', 'RESERVATION CANCELLED');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('9', 'PRN', 'RESERVATION_PERFORMED', 'RESERVATION_PERFORMED');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('10', 'PRN', 'COMPLETED', 'COMPLETED');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('11', 'PRN', 'REJECTED', 'REJECTED');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('12', 'PRN', 'CANCELLED', 'CANCELLED');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('14', 'PRN', 'RESERVATION CREATED', 'RESERVATION CREATED');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('54', 'PRN', 'AUTOMATICALLY ACCEPTED', 'AUTOMATICALLY ACCEPTED');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('56', 'PRN', 'ISSUE IN COMPLETING RESERVATION SOLVED', 'ISSUE IN COMPLETING RESERVATION SOLVED');

-- TFR --
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('15', 'TFR', 'SUBMIT', 'SUBMIT');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('16', 'TFR', 'ISSUE IN COMPLETING NI', 'ISSUE IN COMPLETING NI');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('17', 'TFR', 'ISSUE IN COMPLETING NI SOLVED', 'ISSUE IN COMPLETING NI SOLVED');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('18', 'TFR', 'CROSS-CONNECTION REQUIRED', 'CROSS-CONNECTION REQUIRED');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('19', 'TFR', 'NO CROSS-CONNECTION REQUIRED', 'NO CROSS-CONNECTION REQUIRED');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('21', 'TFR', 'XC COMPLETED', 'XC COMPLETED');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('22', 'TFR', 'LOADED A & Z SITE TASKS', 'LOADED A & Z SITE TASKS');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('23', 'TFR', 'LOADED INTERMEDIATE SITE TASKS', 'LOADED INTERMEDIATE SITE TASKS');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('24', 'TFR', 'COMPLETED', 'COMPLETED');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('25', 'TFR', 'REVISED', 'REVISED');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('26', 'TFR', 'FA COMPLETED', 'FA COMPLETED');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('27', 'TFR', 'REJECTED', 'REJECTED');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('28', 'TFR', 'REJECTION REJECTED', 'REJECTION REJECTED');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('29', 'TFR', 'REJECTION FIXED', 'REJECTION FIXED');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('33', 'TFR', 'NO CROSS-CONNECTION REQUIRED FOR CANCEL', 'NO CROSS-CONNECTION REQUIRED FOR CANCEL');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('34', 'TFR', 'CROSS-CONNECTION REQUIRED FOR CANCEL', 'CROSS-CONNECTION REQUIRED FOR CANCEL');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('35', 'TFR', 'XC CANCELLED', 'XC CANCELLED');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('36', 'TFR', 'CANCELLED', 'CANCELLED');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('55', 'TFR', 'AUTOMATICALLY ACCEPTED', 'AUTOMATICALLY ACCEPTED');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('59', 'TFR', 'NEW', 'NEW');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('60', 'TFR', 'SWITCH ACTIVATION COMPLETED', 'SWITCH ACTIVATION COMPLETED');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('61', 'TFR', 'SWITCH ACTIVATION NOT REQUIRED', 'SWITCH ACTIVATION NOT REQUIRED');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('62', 'TFR', 'SWITCH ACTIVATION REQUIRED', 'SWITCH ACTIVATION REQUIRED');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('64', 'TFR', 'RESERVATION RELEASED IN GRANITE', 'RESERVATION RELEASED IN GRANITE');

-- TFR Task --
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('37', 'TFR_TASK', 'ACCEPTED', 'ACCEPTED');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('38', 'TFR_TASK', 'QUALITY_ACCEPTED', 'QUALITY_ACCEPTED');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('39', 'TFR_TASK', 'SITE_ACCEPTED', 'SITE_ACCEPTED');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('40', 'TFR_TASK', 'REJECTED', 'REJECTED');


-- BI --
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('41','BI','NEW','NEW');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('42','BI','ASSIGNED','ASSIGNED');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('46','BI','MOP ISSUED','MOP ISSUED');
insert into STC_STATUS_MAPPING (STATUS_MAPPING_ID, OBJECT_TYPE, INTERNAL_STATUS, GUI_STATUS) values ('49','BI','COMPLETED','COMPLETED');

commit;