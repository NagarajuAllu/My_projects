/**
 * There are differences between the old and the new provisioning process for SIP orders:
 * - old: there is only 1 workorder
 * - new: there is 1 WorkOrder for Service and 1 WorkOrder for SubService
 * So, for migrated orders, the only 1 WO is assigned both the Service and to SubService
 * but the provisioning process for SubService has not to be started.
 *
 * So, disable provisioning flag in orchestration for subservice!
 */

update stc_order_orchestration o
   set o.provisionable = 0
 where o.elementtypeinorchestration = 'S'
   and o.cworderid in (select h.cworderid
                         from stc_bundleorder_header h, stc_om_home_sip s
                        where s.parentordernumber = h.ordernumber
                          and h.ismigrated = 1);