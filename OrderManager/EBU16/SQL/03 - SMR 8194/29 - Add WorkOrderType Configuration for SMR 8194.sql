-- to allow WD to compute the proper WorkOrderType for Revise for Suspend, Resume, Disconnect
INSERT INTO stc_map_workordertype (ordertype, lineitemaction, workordertype) VALUES ('E', 'M', 'E');
INSERT INTO stc_map_workordertype (ordertype, lineitemaction, workordertype) VALUES ('O', 'M', 'O');
INSERT INTO stc_map_workordertype (ordertype, lineitemaction, workordertype) VALUES ('D', 'M', 'D');

COMMIT;