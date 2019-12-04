define DEFAULT_TABLESPACE_TABLE = CWH;
define DEFAULT_TABLESPACE_INDEX = CWH_NDX;

-- Create table
create table CWORDERINSTANCE_ARCHIVE (
  cwdocid           VARCHAR2(16) not null,
  metadatatype      NUMBER(9) not null,
  status            VARCHAR2(1),
  state             VARCHAR2(16) not null,
  visualkey         VARCHAR2(64) not null,
  productcode       VARCHAR2(256),
  creationdate      DATE not null,
  createdby         VARCHAR2(64) not null,
  updatedby         VARCHAR2(64) not null,
  lastupdateddate   DATE not null,
  parentorder       VARCHAR2(16),
  owner             VARCHAR2(64),
  state2            VARCHAR2(16),
  hasattachment     NUMBER(1) not null,
  metadatatype_ver  NUMBER(9) not null,
  original_order_id VARCHAR2(16),
  source_order_id   VARCHAR2(16),
  kind_of_order     VARCHAR2(1),
  order_phase       VARCHAR2(1),
  project_id        VARCHAR2(16),
  process_id        NUMBER(16),
  cworderstamp      VARCHAR2(9),
  cwdocstamp        VARCHAR2(9),
  duedate           DATE,
  when_archived     DATE default sysdate
)
tablespace &DEFAULT_TABLESPACE_TABLE
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 1M
    next 1M
    minextents 1
    maxextents unlimited
  );


-- Create table
create table CWORDERITEMS_ARCHIVE (
  toporderid          VARCHAR2(16) not null,
  parentid            VARCHAR2(16),
  itemid              VARCHAR2(16) not null,
  metadatatype        VARCHAR2(512) not null,
  pos                 NUMBER(5) not null,
  instancekey         VARCHAR2(512) not null,
  hasattachment       NUMBER(1) not null,
  state               VARCHAR2(16),
  process_id          NUMBER(16),
  search_key          VARCHAR2(128),
  order_creation_date DATE,
  when_archived       DATE default sysdate
)
tablespace &DEFAULT_TABLESPACE_TABLE
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 10M
    next 1M
    minextents 1
    maxextents unlimited
  );
