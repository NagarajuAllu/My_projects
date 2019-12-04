/***

define DEFAULT_TABLESPACE_TABLE = CWE;
define DEFAULT_TABLESPACE_INDEX = CWE_NDX;

***/


define DEFAULT_TABLESPACE_TABLE = STC_DATA;
define DEFAULT_TABLESPACE_INDEX = STC_DATA;


drop table STC_ORDERHEADER_VALIDMAP_NOCHG;
create table STC_ORDERHEADER_VALIDMAP_NOCHG (
  ORDERTYPE            varchar2(25) not null,
  CUSTOMERIDNUMBER     number(1),
  ACCOUNTNUMBER        number(1),
  CUSTOMERTYPE         number(1),
  CUSTOMERIDTYPE       number(1),
  CUSTOMERCONTACT      number(1),
  CUSTOMERCONTACTNAME  number(1),
  CUSTOMERNAME         number(1),
  CUSTOMERNUMBER       number(1),
  CREATEDBYNAME        number(1),
  CREATEDBYCONTACTNAME number(1),
  SERVICEDATE          number(1),
  PRIORITY             number(1),
  REMARKS              number(1),
  REFERENCETELNUMBER   number(1),
  VERSION              number(1),
  CUSTOMERSEGMENTATION number(1),
  FEASIBILITYFOR       number(1),
  RESERVATION          number(1),
  RESERVATIONNUMBER    number(1),
  ICMSSALESORDERNUMBER number(1)
)
tablespace &DEFAULT_TABLESPACE_TABLE;

-- Create/Recreate primary, unique and foreign key constraints 
alter table STC_ORDERHEADER_VALIDMAP_NOCHG
  add constraint PK_STC_ORDERHEADER_VMAP_NOCHG primary key (ORDERTYPE)
  using index 
  tablespace &DEFAULT_TABLESPACE_INDEX;

  

drop table STC_LINEITEM_VALIDMAP_NOCHG;
create table STC_LINEITEM_VALIDMAP_NOCHG(
	ORDERTYPE                   varchar2(25) not null,
    LINEITEMIDENTIFIER          number(1),
	LINEITEMTYPE                number(1),
    SERVICETYPE                 number(1),
    SERVICENUMBER               number(1),
	OLDSERVICENUMBER            number(1),
	PRODUCTTYPE                 number(1),
	REMARKS                     number(1),
	REFERENCETELNUMBER          number(1),
	SERVICEDESCRIPTION          number(1),
	BANDWIDTH                   number(1),
	ACCOUNTNUMBER               number(1),
	OLDACCOUNTNUMBER            number(1),
	PROJECTID                   number(1),
	LOCATIONACITY               number(1),
	LOCATIONACCLICODE           number(1),
	LOCATIONAACCESSCIRCUIT      number(1),
	LOCATIONAJVCODE             number(1),
	LOCATIONAEXCHANGESWITCHCODE number(1),
	LOCATIONAACCESSTYPE         number(1),
	LOCATIONAPLATEID            number(1),
	LOCATIONAOLDPLATEID         number(1),
	LOCATIONACONTACTADDRESS     number(1),
	LOCATIONACONTACTNAME        number(1),
	LOCATIONACONTACTTEL         number(1),
	LOCATIONACONTACTEMAIL       number(1),
	LOCATIONAUNITNUMBER         number(1),
	LOCATIONAINTERFACE          number(1),
	LOCATIONAREMARKS            number(1),
	LOCATIONBCITY               number(1),
	LOCATIONBCCLICODE           number(1),
	LOCATIONBACCESSCIRCUIT      number(1),
	LOCATIONBJVCODE             number(1),
	LOCATIONBEXCHANGESWITCHCODE number(1),
	LOCATIONBACCESSTYPE         number(1),
	LOCATIONBPLATEID            number(1),
	LOCATIONBOLDPLATEID         number(1),
	LOCATIONBCONTACTADDRESS     number(1),
	LOCATIONBCONTACTNAME        number(1),
	LOCATIONBCONTACTTEL         number(1),
	LOCATIONBCONTACTEMAIL       number(1),
	LOCATIONBUNITNUMBER         number(1),
	LOCATIONBINTERFACE          number(1),
	LOCATIONBREMARKS            number(1),
	TBPORTNUMBER                number(1),
	WIRES                       number(1),
	SERVICEDATE                 number(1),
	CREATIONDATE                number(1),
    DEPENDENCIES                number(1)
)
TABLESPACE &DEFAULT_TABLESPACE_TABLE;

-- Create/Recreate primary, unique and foreign key constraints 
alter table STC_LINEITEM_VALIDMAP_NOCHG
  add constraint PK_STC_LINEITEM_VALIDMAP_NOCHG primary key (ORDERTYPE)
  using index 
  tablespace &DEFAULT_TABLESPACE_INDEX;
