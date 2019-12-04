-- THIS ONE HAS TO BE EXECUTED FROM SYSTEM!!!

create user cwe_downgrade
identified by cwe_downgrade
default tablespace CWE
temporary tablespace TEMP;
  
grant connect to cwe_downgrade;
grant resource to cwe_downgrade;


grant select on CWE_BUNDLE.STC_BUNDLEORDER_HEADER to cwe_downgrade;
grant select on CWE_BUNDLE.STC_LINEITEM to cwe_downgrade;
grant select on CWE_BUNDLE.STC_NAME_VALUE to cwe_downgrade;
grant select on CWE_BUNDLE.CWORDERINSTANCE to cwe_downgrade;
grant select on CWE_BUNDLE.CWORDERITEMS to cwe_downgrade;
grant select on CWE_BUNDLE.STC_PRODUCTTYPE_NAME_MAP to cwe_downgrade;


