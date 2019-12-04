DROP TABLE cwmessagelog_archive;
CREATE TABLE cwmessagelog_archive(
  msgid                    NUMBER(16),
  vmid                     NUMBER(8),
  inter_type               NUMBER(9),
  operation                VARCHAR2(256),
  user_id                  VARCHAR2(64),
  user_data1               VARCHAR2(64),
  user_data2               VARCHAR2(64),
  user_data3               VARCHAR2(64),
  creation_time            TIMESTAMP(6),
  send_data                BLOB,
  send_time                TIMESTAMP(6),
  receive_data             BLOB,
  receive_time             TIMESTAMP(6),
  receive_charset          VARCHAR2(16),
  send_msg_priority        VARCHAR2(1),
  receive_msg_priority     VARCHAR2(1),
  send_msg_seqid           VARCHAR2(128),
  receive_msg_seqid        VARCHAR2(128),
  send_msg_retrycount      NUMBER(3),
  receive_msg_retrycount   NUMBER(3),
  send_msg_correltionid    VARCHAR2(128),
  receive_msg_correltionid VARCHAR2(128),
  send_msg_props           BLOB,
  receive_msg_props        BLOB
);

DROP TABLE cwprocesseventlog_archive;
CREATE TABLE cwprocesseventlog_archive(
  event_source   NUMBER(2),
  event_severity NUMBER(1),
  event_code     NUMBER(4),
  description    VARCHAR2(1024),
  event_time     TIMESTAMP(6),
  user_id        VARCHAR2(64),
  metadata_type  VARCHAR2(256),
  metadata_ver   NUMBER(9),
  object_id      VARCHAR2(256),
  external_code  VARCHAR2(8),
  external_type  VARCHAR2(64),
  qualified_name VARCHAR2(256),
  stack_trace    VARCHAR2(4000),
  node_id        VARCHAR2(50)
);

DROP TABLE archiving_op_log;
CREATE TABLE archiving_op_log(
  operation_time DATE,
  operation VARCHAR2(100),
  error_msg VARCHAR2(1000)
);


CREATE OR REPLACE PROCEDURE Archive_CWEVENTLOG_Entries
AS
  pdate        DATE;
  num_of_days  NUMBER(5) := 340;  -- number of days has to be left
  count_rows   NUMBER(9) := 0;    -- row will be deleted
  rows_in_iter NUMBER(4) := 1000; -- number of rows deleted in each iteration
  num_of_iters NUMBER(9) := 0;    -- number of iterations
  counter      NUMBER(9) := 0;

  error_msg         VARCHAR2(1000);

BEGIN
  INSERT INTO archiving_op_log VALUES(sysdate, 'ARCHIVE_CWPROCESSEVENTLOG_ENTRIES', 'Started');
  COMMIT;
  BEGIN

  pdate := TRUNC(SYSDATE) - num_of_days; -- start of today

  INSERT INTO archiving_op_log VALUES(sysdate, 'ARCHIVE_CWPROCESSEVENTLOG_ENTRIES', 'Deleting records older than: ' || to_char(pdate, 'yyyy/mm/dd'));

/***
    INSERT INTO cwprocesseventlog_archive
     SELECT *
       FROM cwprocesseventlog
      WHERE event_time <= pdate;
***/

    SELECT COUNT(*), CEIL(COUNT(*)/rows_in_iter)
      INTO count_rows, num_of_iters
      FROM cwprocesseventlog
     WHERE event_time <= pdate;

    INSERT INTO archiving_op_log VALUES(sysdate, 'ARCHIVE_CWPROCESSEVENTLOG_ENTRIES', 'Rows: ' || count_rows);
    INSERT INTO archiving_op_log VALUES(sysdate, 'ARCHIVE_CWPROCESSEVENTLOG_ENTRIES', '# Iterations: ' || num_of_iters);

    WHILE(counter < num_of_iters) LOOP
      BEGIN
        INSERT INTO archiving_op_log VALUES(sysdate, 'ARCHIVE_CWPROCESSEVENTLOG_ENTRIES', 'Iteration # '||counter);

        DELETE
          FROM cwprocesseventlog
         WHERE event_time <= pdate
           AND rownum <= rows_in_iter;

        COMMIT;

        counter := counter + 1;

      END;
    END LOOP;

    COMMIT;
  EXCEPTION
    WHEN others THEN
      error_msg := SUBSTR(sqlerrm, 1, 1000);
      INSERT INTO archiving_op_log VALUES(sysdate, 'ARCHIVE_CWPROCESSEVENTLOG_ENTRIES', error_msg);
    COMMIT;
  END;

INSERT INTO archiving_op_log VALUES(sysdate, 'ARCHIVE_CWPROCESSEVENTLOG_ENTRIES', 'Completed');
COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE Archive_CWMESSAGELOG_Entries
AS
  pdate        DATE;
  num_of_days  NUMBER(5) := 340;  -- number of days has to be left
  count_rows   NUMBER(9) := 0;    -- row will be deleted
  rows_in_iter NUMBER(4) := 1000; -- number of rows deleted in each iteration
  num_of_iters NUMBER(9) := 0;    -- number of iterations
  counter      NUMBER(9) := 0;

  error_msg   VARCHAR2(1000);
BEGIN

  INSERT INTO archiving_op_log VALUES(sysdate, 'ARCHIVE_CWMESSAGELOG_ENTRIES', 'Start');
  COMMIT;

  BEGIN
    pdate := TRUNC(SYSDATE) - num_of_days; -- start of today

  INSERT INTO archiving_op_log VALUES(sysdate, 'ARCHIVE_CWMESSAGELOG_ENTRIES', 'Deleting records older than: ' || to_char(pdate, 'yyyy/mm/dd'));

/*
    INSERT INTO cwmessagelog_archive
     SELECT *
       FROM cwmessagelog
      WHERE creation_time <= pdate;
*/

    SELECT COUNT(*), CEIL(COUNT(*)/rows_in_iter)
      INTO count_rows, num_of_iters
      FROM cwmessagelog
     WHERE creation_time <= pdate;

    INSERT INTO archiving_op_log VALUES(sysdate, 'ARCHIVE_CWMESSAGELOG_ENTRIES', 'Rows: ' || count_rows);
    INSERT INTO archiving_op_log VALUES(sysdate, 'ARCHIVE_CWMESSAGELOG_ENTRIES', '# Iterations: ' || num_of_iters);

    WHILE(counter < num_of_iters) LOOP
      BEGIN
        INSERT INTO archiving_op_log VALUES(sysdate, 'ARCHIVE_CWMESSAGELOG_ENTRIES', 'Iteration # '||counter);

        DELETE
          FROM cwmessagelog
         WHERE creation_time <= pdate
           AND rownum <= rows_in_iter;

        COMMIT;

        counter := counter + 1;

      END;
    END LOOP;

    COMMIT;
  EXCEPTION
    WHEN others THEN
      error_msg := SUBSTR(sqlerrm, 1, 1000);
      INSERT INTO archiving_op_log VALUES(sysdate, 'ARCHIVE_CWMESSAGELOG_ENTRIES', error_msg);
    COMMIT;
  END;

INSERT INTO archiving_op_log VALUES(sysdate, 'ARCHIVE_CWMESSAGELOG_ENTRIES', 'Completed');
COMMIT;
END;
/

-- ALTER SYSTEM SET JOB_QUEUE_PROCESSES = 10;

VARIABLE jobno number;
BEGIN
   -- daily
   DBMS_JOB.SUBMIT(:jobno,'Archive_CWMESSAGELOG_Entries(); commit;', to_date(to_char(sysdate+1, 'yyyy/MM/dd') || ' 02:00:00', 'yyyy/MM/dd hh24:mi:ss'),'SYSDATE + 1');
   commit;
END;
/
COMMIT;

BEGIN
   -- daily
   DBMS_JOB.SUBMIT(:jobno,'Archive_CWEVENTLOG_Entries(); commit;', to_date(to_char(sysdate, 'yyyy/MM/dd') || ' 22:00:00', 'yyyy/MM/dd hh24:mi:ss'),'SYSDATE + 1');
   commit;
END;
/
COMMIT;
