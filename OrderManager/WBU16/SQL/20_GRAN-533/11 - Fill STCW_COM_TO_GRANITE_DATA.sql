delete from stcw_com_to_granite_data where cim = 'H';

-- Mapping OH -> OH
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('customerIdNumber','OH',null,'customerNumber','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('accountNumber','OH',null,'accountNumber','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('customerType','OH',null,'customerType','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('customerIDType','OH',null,'customerIDType','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('customerContact','OH',null,'customerContact','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('customerName','OH',null,'customerName','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('orderNumber','OH',null,'parentOrderNumber','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('creationDate','OH',null,'creationDate','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('createdBy','OH',null,'createdBy','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('serviceDate','OH',null,'serviceDate','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('priority','OH',null,'priority','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('icmsSalesOrderNumber','OH',null,'icmsSONumber','OH','H','O');

-- Mapping LI -> OH
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('workOrderNumber','LI',null,'orderNumber','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('workOrderType','LI',null,'orderType','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('serviceNumber','LI','F001','circuitNumber','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('reservationNumber','LI',null,'reservationNumber','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('oldServiceNumber','LI','F001','oldCircuitNumber','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('remarks','LI',null,'remarks','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('fictBillingNumber','LI','F001','fictBillingNumber','OH','H','O');
-- Removed as requested by Raj with email on 2019-01-21
-- insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('bandwidth','LI','F002','bandwidth','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('projectId','LI',null,'projectId','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('locationACity','LI','F001','locationACity','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('locationACCLICode','LI','F001','locationACCLICode','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('locationAAccessCircuit','LI','F001','locationAAccessCircuit','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('locationAJVCode','LI','F001','locationAJVCode','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('locationAExchangeSwitchCode','LI','F001','locationAExchangeSwitchCode','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('locationAAccessType','LI','F001','locationAAccessType','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('locationACCLICode','LI','F001','locationAPlateID','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('locationAOldPlateID','LI','F001','oldPlateId','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('locationAContactAddress','LI','F001','locationAContactAddress','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('locationAContactName','LI','F001','locationAContactName','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('locationAContactTel','LI','F001','locationAContactTel','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('locationAContactEmail','LI','F001','locationAContactEmail','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('locationAInterface','LI','F001','locationAInterface','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('locationARemarks','LI','F001','locationARemarks','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('locationBCity','LI','F001','locationBCity','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('locationBCCLICode','LI','F001','locationBCCLICode','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('locationBAccessCircuit','LI','F001','locationBAccessCircuit','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('locationBJVCode','LI','F001','locationBJVCode','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('locationBExchangeSwitchCode','LI','F001','locationBExchangeSwitchCode','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('locationBAccessType','LI','F001','locationBAccessType','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('locationBCCLICode','LI','F001','locationBPlateID','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('locationBContactAddress','LI','F001','locationBContactAddress','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('locationBContactName','LI','F001','locationBContactName','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('locationBContactTel','LI','F001','locationBContactTel','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('locationBContactEmail','LI','F001','locationBContactEmail','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('locationBInterface','LI','F001','locationBInterface','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('locationBRemarks','LI','F001','locationBRemarks','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('wires','LI','F001','wires','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('serviceDescription','LI','F001','serviceDescription','OH','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('locationACCLICode','LI','F001','plateID','OH','H','O');

-- Mapping NV -> OH
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('PrimaryPhoneNumber','NV','F001','referenceTelNumber','OH','H','O');



-- Mapping OH -> LI
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('feasibilityFor','OH',null,'feasibilityFor','LI','H','O');

-- Mapping LI -> LI
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('orderRowItemId','LI',null,'orderRowItemID','LI','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('serviceType','LI',null,'serviceType','LI','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('oldServiceNumber','LI',null,'oldServiceNumber','LI','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('changeRequestType','LI',null,'changeRequestType','LI','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('locationACCLICode','LI',null,'plateID','LI','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('locationAOldPlateID','LI',null,'oldPlateId','LI','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('locationAUnitNumber','LI',null,'unitNumber','LI','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('serviceDescription','LI',null,'serviceDescription','LI','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('serviceDate','LI',null,'serviceDate','LI','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('creationDate','LI',null,'creationDate','LI','H','O');

-- Mapping NV -> LI
-- Removed as requested by Raj with email on 2019-01-20
-- insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('PrimaryPhoneNumber','NV',null,'serviceNumber','LI','H','O');



-- Mapping OH -> NV
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('orderType','OH',null,'CRMOrderType','NV','H','O');

-- Mapping LI -> NV
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('serviceNumber','LI',null,'OLO Service Number','NV','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('referenceTelNumber','LI',null,'Service Account Number','NV','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('action','LI',null,'LineItem Action','NV','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('locationACCLICode', 'LI', 'F001', 'Initial_PlateID', 'NV', 'H', 'O');

-- Mapping NV -> NV (F001)
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('Instalation','NV','F001','Instalation','NV','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('CustomerAccountNumber','NV','F001','EndCustomerAccountNumber','NV','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('CustomerName','NV','F001','EndCustomerName','NV','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('AppointmentDate','NV','F001','AppointmentDate','NV','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('AppointmentID','NV','F001','AppointmentID','NV','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('AppointmentPhoneNumber','NV','F001','AppointmentPhoneNumber','NV','H','O');

-- Mapping NV -> NV (ONT)
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('ONT_Serial_Number','NV','F005','ONT Serial Number','NV','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('ONT_FaultyType','NV','F005','ONT Faulty Type','NV','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('ONT_Model_Type','NV','F005','ONT Model Type','NV','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('ONT_MAC_Address','NV','F005','ONT MAC Address','NV','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('ONT_In-Warranty','NV','F005','ONT In Warranty','NV','H','O');

-- Mapping NV -> NV (STB)
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('STB_Serial_Number','NV','F006','STB Serial Number','NV','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('STB_FaultyType','NV','F006','STB Faulty Type','NV','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('STB_Model_Type','NV','F006','STB Model Type','NV','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('STB_MAC_Address','NV','F006','STB MAC Address','NV','H','O');
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('STB_In-Warranty','NV','F006','STB In Warranty','NV','H','O');

-- Mapping NV_PLI -> NV 
insert into STCW_COM_TO_GRANITE_DATA(COM_NAME, COM_ELEMENT, COM_SERVICETYPE, GI_NAME, GI_ELEMENT, CIM, O_Q) values ('AC_Meter','NV_PLI',null,'AC_Meter','NV','H','O');

commit;
