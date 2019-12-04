CREATE OR REPLACE VIEW STC_EXPEDITOR_WBU_QUOTEINFO
(wo_name, wo_status, wo_comments, feasibility_status, actual_implementation_days, planned_feasible_days, reservation_days)
AS
select distinct w.WO_NAME, w.STATUS, W.COMMENTS,
(SELECT RAS1.ATTR_VALUE FROM resource_attr_settings ras1, val_attr_name van 
                WHERE van.GROUP_NAME like 'SWO Attributes' and van.ATTR_NAME LIKE 'Feasibility Status'and van.VAL_ATTR_INST_ID = ras1.VAL_ATTR_INST_ID 
                and ras1.RESOURCE_INST_ID = ri.RESOURCE_INST_ID) FEASIBILITY_STATUS,
(SELECT RAS1.ATTR_VALUE FROM resource_attr_settings ras1, val_attr_name van 
                WHERE van.GROUP_NAME like 'SWO Attributes' and van.ATTR_NAME LIKE 'Implementation Days'and van.VAL_ATTR_INST_ID = ras1.VAL_ATTR_INST_ID 
                and ras1.RESOURCE_INST_ID = ri.RESOURCE_INST_ID) ACTUAL_IMPLEMENTATION_DAYS,
(SELECT RAS1.ATTR_VALUE FROM resource_attr_settings ras1, val_attr_name van 
                WHERE van.GROUP_NAME like 'SWO Attributes' and van.ATTR_NAME LIKE 'Planned Resource Feasible Days'and van.VAL_ATTR_INST_ID = ras1.VAL_ATTR_INST_ID 
                and ras1.RESOURCE_INST_ID = ri.RESOURCE_INST_ID) PLANNED_FEASIBLE_DAYS,                
(SELECT RAS1.ATTR_VALUE FROM resource_attr_settings ras1, val_attr_name van 
                WHERE van.GROUP_NAME like 'SWO Attributes' and van.ATTR_NAME LIKE 'Reservation Days'and van.VAL_ATTR_INST_ID = ras1.VAL_ATTR_INST_ID 
                and ras1.RESOURCE_INST_ID = ri.RESOURCE_INST_ID) RESERVATION_DAYS
from WORK_ORDER_INST W, resource_inst ri, 
val_attr_name van, workorder_attr_settings was
where w.STATUS in (7,8) and w.DEFINITION_INST_ID like '1440' --1440 = "Quotation" objectType under WO
and w.ELEMENT_INST_ID = ri.RESOURCE_INST_ID
and w.WO_INST_ID = was.WORKORDER_INST_ID
and was.ATTR_VALUE like 'wbu__domain'
and was.VAL_ATTR_INST_ID = van.VAL_ATTR_INST_ID
and van.GROUP_NAME like 'Work Order Info' and van.ATTR_NAME like 'Domain'

union

--WO_INST join DEL_RESOURCE_INST
select distinct w.WO_NAME, w.STATUS, W.COMMENTS,
(SELECT RAS1.ATTR_VALUE FROM del_resource_attr_settings ras1, val_attr_name van 
                WHERE van.GROUP_NAME like 'SWO Attributes' and van.ATTR_NAME LIKE 'Feasibility Status'and van.VAL_ATTR_INST_ID = ras1.VAL_ATTR_INST_ID 
                and ras1.RESOURCE_INST_ID = ri.RESOURCE_INST_ID) FEASIBILITY_STATUS,
(SELECT RAS1.ATTR_VALUE FROM del_resource_attr_settings ras1, val_attr_name van 
                WHERE van.GROUP_NAME like 'SWO Attributes' and van.ATTR_NAME LIKE 'Implementation Days'and van.VAL_ATTR_INST_ID = ras1.VAL_ATTR_INST_ID 
                and ras1.RESOURCE_INST_ID = ri.RESOURCE_INST_ID) ACTUAL_IMPLEMENTATION_DAYS,
(SELECT RAS1.ATTR_VALUE FROM del_resource_attr_settings ras1, val_attr_name van 
                WHERE van.GROUP_NAME like 'SWO Attributes' and van.ATTR_NAME LIKE 'Planned Resource Feasible Days'and van.VAL_ATTR_INST_ID = ras1.VAL_ATTR_INST_ID 
                and ras1.RESOURCE_INST_ID = ri.RESOURCE_INST_ID) PLANNED_FEASIBLE_DAYS,                
(SELECT RAS1.ATTR_VALUE FROM del_resource_attr_settings ras1, val_attr_name van 
                WHERE van.GROUP_NAME like 'SWO Attributes' and van.ATTR_NAME LIKE 'Reservation Days'and van.VAL_ATTR_INST_ID = ras1.VAL_ATTR_INST_ID 
                and ras1.RESOURCE_INST_ID = ri.RESOURCE_INST_ID) RESERVATION_DAYS
from WORK_ORDER_INST W, del_resource_inst ri, 
val_attr_name van, workorder_attr_settings was
where w.STATUS in (7,8) and w.DEFINITION_INST_ID like '1440'  --1440 = "Quotation" objectType under WO
and w.ELEMENT_INST_ID = ri.RESOURCE_INST_ID
and w.WO_INST_ID = was.WORKORDER_INST_ID
and was.ATTR_VALUE like 'wbu__domain'
and was.VAL_ATTR_INST_ID = van.VAL_ATTR_INST_ID
and van.GROUP_NAME like 'Work Order Info' and van.ATTR_NAME like 'Domain'

union

--DEL_WO_INST join RESOURCE_INST
select distinct w.WO_NAME, w.STATUS, W.COMMENTS,
(SELECT RAS1.ATTR_VALUE FROM resource_attr_settings ras1, val_attr_name van 
                WHERE van.GROUP_NAME like 'SWO Attributes' and van.ATTR_NAME LIKE 'Feasibility Status'and van.VAL_ATTR_INST_ID = ras1.VAL_ATTR_INST_ID 
                and ras1.RESOURCE_INST_ID = ri.RESOURCE_INST_ID) FEASIBILITY_STATUS,
(SELECT RAS1.ATTR_VALUE FROM resource_attr_settings ras1, val_attr_name van 
                WHERE van.GROUP_NAME like 'SWO Attributes' and van.ATTR_NAME LIKE 'Implementation Days'and van.VAL_ATTR_INST_ID = ras1.VAL_ATTR_INST_ID 
                and ras1.RESOURCE_INST_ID = ri.RESOURCE_INST_ID) ACTUAL_IMPLEMENTATION_DAYS,
(SELECT RAS1.ATTR_VALUE FROM resource_attr_settings ras1, val_attr_name van 
                WHERE van.GROUP_NAME like 'SWO Attributes' and van.ATTR_NAME LIKE 'Planned Resource Feasible Days'and van.VAL_ATTR_INST_ID = ras1.VAL_ATTR_INST_ID 
                and ras1.RESOURCE_INST_ID = ri.RESOURCE_INST_ID) PLANNED_FEASIBLE_DAYS,                
(SELECT RAS1.ATTR_VALUE FROM resource_attr_settings ras1, val_attr_name van 
                WHERE van.GROUP_NAME like 'SWO Attributes' and van.ATTR_NAME LIKE 'Reservation Days'and van.VAL_ATTR_INST_ID = ras1.VAL_ATTR_INST_ID 
                and ras1.RESOURCE_INST_ID = ri.RESOURCE_INST_ID) RESERVATION_DAYS
from del_WORK_ORDER_INST W, resource_inst ri, 
val_attr_name van, workorder_attr_settings was
where w.STATUS in (7,8) and w.DEFINITION_INST_ID like '1440'  --1440 = "Quotation" objectType under WO
and w.ELEMENT_INST_ID = ri.RESOURCE_INST_ID
and w.WO_INST_ID = was.WORKORDER_INST_ID
and was.ATTR_VALUE like 'wbu__domain'
and was.VAL_ATTR_INST_ID = van.VAL_ATTR_INST_ID
and van.GROUP_NAME like 'Work Order Info' and van.ATTR_NAME like 'Domain'

union

--DEL_WO_INST join DEL_RESOURCE_INST
select distinct w.WO_NAME, w.STATUS, W.COMMENTS,
(SELECT RAS1.ATTR_VALUE FROM del_resource_attr_settings ras1, val_attr_name van 
                WHERE van.GROUP_NAME like 'SWO Attributes' and van.ATTR_NAME LIKE 'Feasibility Status'and van.VAL_ATTR_INST_ID = ras1.VAL_ATTR_INST_ID 
                and ras1.RESOURCE_INST_ID = ri.RESOURCE_INST_ID) FEASIBILITY_STATUS,
(SELECT RAS1.ATTR_VALUE FROM del_resource_attr_settings ras1, val_attr_name van 
                WHERE van.GROUP_NAME like 'SWO Attributes' and van.ATTR_NAME LIKE 'Implementation Days'and van.VAL_ATTR_INST_ID = ras1.VAL_ATTR_INST_ID 
                and ras1.RESOURCE_INST_ID = ri.RESOURCE_INST_ID) ACTUAL_IMPLEMENTATION_DAYS,
(SELECT RAS1.ATTR_VALUE FROM del_resource_attr_settings ras1, val_attr_name van 
                WHERE van.GROUP_NAME like 'SWO Attributes' and van.ATTR_NAME LIKE 'Planned Resource Feasible Days'and van.VAL_ATTR_INST_ID = ras1.VAL_ATTR_INST_ID 
                and ras1.RESOURCE_INST_ID = ri.RESOURCE_INST_ID) PLANNED_FEASIBLE_DAYS,                
(SELECT RAS1.ATTR_VALUE FROM del_resource_attr_settings ras1, val_attr_name van 
                WHERE van.GROUP_NAME like 'SWO Attributes' and van.ATTR_NAME LIKE 'Reservation Days'and van.VAL_ATTR_INST_ID = ras1.VAL_ATTR_INST_ID 
                and ras1.RESOURCE_INST_ID = ri.RESOURCE_INST_ID) RESERVATION_DAYS
from del_WORK_ORDER_INST W, del_resource_inst ri, 
val_attr_name van, workorder_attr_settings was
where w.STATUS in (7,8) and w.DEFINITION_INST_ID like '1440'  --1440 = "Quotation" objectType under WO
and w.ELEMENT_INST_ID = ri.RESOURCE_INST_ID
and w.WO_INST_ID = was.WORKORDER_INST_ID
and was.ATTR_VALUE like 'wbu__domain'
and was.VAL_ATTR_INST_ID = van.VAL_ATTR_INST_ID
and van.GROUP_NAME like 'Work Order Info' and van.ATTR_NAME like 'Domain'
;
