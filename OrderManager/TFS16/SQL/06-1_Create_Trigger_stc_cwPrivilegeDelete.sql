create or replace trigger STC_CWPRIVILEGE_DEL_TRG
  before delete on CWPRIVILEGE 
  for each row 
  
declare
  -- local variables here
begin
 
  if(:old.privilege in ('STC_IOrdInitPriv', 'STC_IntegPriv', 'STC_NetwDesPriv', 
                        'STC_FacilityDes', 'STC_SwchActvPriv', 'STC_VerificPriv',
                        'STC_XCPriv', 'STC_QualityPriv', 'STC_SitePriv', 'STC_ASBuiltPriv', 'STC_TransMapPriv',
                        'STC_BBTransPriv', 'STC_FATxPriv', 'STC_TFAModSqPriv', 'STC_TFAPriv', 'STC_ASPriv', 'STC_FNIPriv',
                        'STC_ConfigPriv' , 'STC_GroupMgrPriv')) then
    raise_application_error(-20101, 'Privilege mandatory for application usage');
  end if;

  if(:old.privilege in ('PMAdmin', 'UPAdmin', 'WLAdmin', 'RTAdmin', 'CWApi', 'PRPriority', 'Everyone', 'WGSelect', 'WDelegate', 
                        'WTakeOn', 'CWAdminApp', 'WGManager', 'WReturn', 'WGAvailable', 'AddFavorite', 'DelFavorite', 'ShowError', 
                        'LPAdmin', 'WLSetAvailable', 'cwt_wzConfig', 'cwt_subscription', 'cwt_coba', 'ModFavorite')) then
    raise_application_error(-20102, 'Privilege mandatory for EOC usage');
  end if;


end STC_CWPRIVILEGE_DEL_TRG;
/
