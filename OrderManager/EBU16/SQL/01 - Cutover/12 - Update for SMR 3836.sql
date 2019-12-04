-- to allow WD to compute the proper WorkOrderType for Feasibility orders
INSERT INTO stc_map_workordertype VALUES ('F', 'A', 'F');
INSERT INTO stc_map_workordertype VALUES ('F', 'C', 'F');
INSERT INTO stc_map_workordertype VALUES ('F', 'M', 'F');
INSERT INTO stc_map_workordertype VALUES ('F', 'D', 'O');


COMMIT;