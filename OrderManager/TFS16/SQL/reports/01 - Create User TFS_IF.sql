-- Create the user 
create user TFS_IF
  identified by tfs_if
  default tablespace TFS_DATA
  temporary tablespace TEMP
  profile DEFAULT;

-- Grant/Revoke role privileges 
grant connect to TFS_IF;
grant create view to TFS_IF;

-- Grant Select on TFS tables
grant select on TFS.STC_USERS4ORDER to TFS_IF;
grant select on TFS.STC_TRACKING to TFS_IF;
grant select on TFS.STC_TFR_TASK to TFS_IF;
grant select on TFS.STC_TFR_REMARKS to TFS_IF;
grant select on TFS.STC_TFR_CUSTOMATTR to TFS_IF;
grant select on TFS.STC_TFR to TFS_IF;
grant select on TFS.STC_PRN_CUSTOMATTR to TFS_IF;
grant select on TFS.STC_PRN to TFS_IF;
grant select on TFS.STC_PRNR_CUSTOMATTR to TFS_IF;
grant select on TFS.STC_PRNR to TFS_IF;
grant select on TFS.STC_CUSTOMATTR_LIST_OPTION to TFS_IF;
grant select on TFS.STC_CUSTOMATTR to TFS_IF;
grant select on TFS.STC_CITY_DISTRICT_REGION to TFS_IF;
grant select on TFS.STC_BI_RELATIONSHIP to TFS_IF;
grant select on TFS.STC_BI_CUSTOMATTR to TFS_IF;
grant select on TFS.STC_BI to TFS_IF;
grant select on TFS.STC_REJECT_QUESTION to TFS_IF;
grant select on TFS.STC_REJECT_ANSWER to TFS_IF;
grant select on TFS.STC_REJECTION_PROCESS to TFS_IF;
grant select on TFS.STC_REJECTION_PROCESS_ACTIVITY to TFS_IF;
grant select on STC_OBJECT_REMARKS to TFS_IF;

grant select on TFS.CWPROCESS to TFS_IF;
grant select on TFS.CWUSER to TFS_IF;
grant select on TFS.CWUSERROLE to TFS_IF;
grant select on TFS.CWUSERGROUPPRIVILEGE to TFS_IF;
grant select on TFS.STC_PRIVILEGE_V to TFS_IF;

grant select on TFS.CWAUDITTRAIL to TFS_IF;
grant select on TFS.CWFIELDAUDITTRAIL to TFS_IF;
grant select on TFS.CWMDTYPES to TFS_IF;
