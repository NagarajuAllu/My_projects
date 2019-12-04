define DEFAULT_TABLESPACE_TABLE = CWE;
define DEFAULT_TABLESPACE_INDEX = CWE_NDX;


DROP TABLE stc_siu_event_stage;


CREATE TABLE stc_siu_event_stage (
  eventId VARCHAR2(16) NOT NULL,
  plateId VARCHAR2(50),
  siteId VARCHAR2(30),
  eventXMLData CLOB,
  eventDate DATE default TRUNC(sysdate),
  eventDateTime DATE default sysdate 
)
tablespace &DEFAULT_TABLESPACE_TABLE;

ALTER TABLE stc_siu_event_stage
  ADD CONSTRAINT pk_stc_siu_event_stage PRIMARY KEY (eventId)
  USING INDEX 
  TABLESPACE &DEFAULT_TABLESPACE_TABLE;


CREATE INDEX siu_event_date ON stc_siu_event_stage(eventDate)
TABLESPACE &DEFAULT_TABLESPACE_INDEX;
