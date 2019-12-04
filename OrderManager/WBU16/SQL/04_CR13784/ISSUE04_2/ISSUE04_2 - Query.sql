set serveroutput on
DECLARE

  TYPE ServiceNumberList IS TABLE OF VARCHAR2(500);
  my_services ServiceNumberList;

  CURSOR serviceData (servNumber VARCHAR2) IS
      SELECT l.servicenumber      ||';'|| 
             l.oldservicenumber   ||';'||
             l.lineitemidentifier ||';'||
             l.lineitemstatus     ||';'||
             h.customeridnumber   ||';'||
             h.customername       ||';'||
             h.customernumber     ||';'||
             l.workordernumber    ||';'||
             l.producttype        ||';'||
             l.servicetype        ||';'||
             l.provisioningFlag   ||';'||
             h.ismigrated  serviceData
        FROM stcw_lineitem l, stcw_bundleorder_header h
       WHERE l.cworderid=h.cworderid
         AND l.provisioningFlag in ('ACTIVE', 'PROVISIONING')
         AND (l.servicenumber = servNumber OR l.oldservicenumber = servNumber);


  errorMsg       VARCHAR2(1000);
  found          NUMBER(1);
  
BEGIN
  
  DBMS_OUTPUT.ENABLE(NULL);

  my_services := ServiceNumberList(
'SD02-0000010-A',
'SD02-0000015-A',
'SD02-0000016-A',
'SD02-0000051-A',
'C004-0000013-B',
'C004-0000013-B',
'C004-0000068-A',
'C004-0000068-A',
'C004-0000068-A',
'C004-0000068-A',
'C004-0000075-A',
'C004-0000075-A',
'C004-0000075-A',
'C004-0000085-C',
'C004-0000089-A',
'C004-0000125-A',
'C004-1000003-A',
'C004-1000004-A',
'C004-1000005-A',
'C004-1000085-C',
'C004-1000125-A',
'C004-2000085-C',
'C004-2000125-A',
'C004-3000085-C',
'C004-3000125-A',
'C004-4000085-C',
'C004-4000125-A',
'C004-4000160-A',
'C004-4000167-A',
'C027-9000160-A',
'C004-4000136-B',
'C004-4000136-B',
'C004-4000143-A',
'C024-0000003-A',
'D003-0000130-A',
'D003-0000130-A',
'D023-0000104-A',
'D023-0000122-A',
'D023-0000124-A',
'C004-0000133-A',
'C004-0000133-B',
'C027-9000111-A',
'SD02-0000034-A',
'4-9719253',
'4-9729221',
'C001-2000028-A',
'C001-2000029-A',
'C001-2000030-A',
'C001-2000043-A',
'C001-2000043-A',
'C001-2000045-A',
'C001-2000046-A',
'C001-2000049-A',
'C001-2000050-A',
'C001-2000086-A',
'C001-2000088-A',
'C001-2000093-A',
'C001-2000098-A',
'C001-2000098-A',
'C001-2000099-A',
'C001-2000099-A',
'C001-2000106-A',
'C001-2000106-A',
'C001-2000112-A',
'C001-2000113-A',
'C001-2000114-A',
'C001-2000115-A',
'C001-2000116-A',
'C001-2000118-A',
'C001-2000118-A',
'C001-2000118-A',
'C003-1000021-A',
'C003-1000022-A',
'C003-1000023-A',
'C003-1000024-A',
'C011-1000023-A',
'C011-1000023-A',
'C011-1000024-A',
'C011-1000024-A',
'D024-0000831-A',
'D024-0000835-A',
'D024-0000969-A',
'D024-0001070-A',
'D15N-1000029-A',
'D15N-1000029-A',
'D15N-1000033-A',
'D15N-1000039-A',
'C004-0000001-A',
'C004-0000002-A',
'C004-0000012-A',
'C004-0000012-A',
'C004-0000013-B',
'C004-0000031-A',
'C004-0000034-A',
'C004-0000036-A',
'C004-0000044-A',
'C004-0000063-A',
'C004-0000068-A',
'C004-0000075-A',
'C004-0000085-C',
'C004-0000087-B',
'C004-0000089-A',
'C004-0000089-A',
'C004-0000089-A',
'C004-0000100-A',
'C004-0000126-A',
'C004-0000127-A',
'C004-0000127-A',
'C004-0000135-A',
'C004-1000044-A',
'C004-1000059-A',
'C004-1000060-A',
'C004-1000061-A',
'C004-1000062-A',
'C004-1000063-A',
'C004-1000064-A',
'C004-1000065-A',
'C004-1000066-A',
'C004-1000067-A',
'C004-1000068-A',
'C004-1000069-A',
'C004-1000070-A',
'C004-1000071-A',
'C004-1000072-A',
'C004-1000073-A',
'C004-1000074-A',
'C004-1000075-A',
'C004-1000076-A',
'C004-1000077-A',
'C004-1000078-A',
'C004-1000079-A',
'C004-1000085-C',
'C004-1000087-B',
'C004-2000044-A',
'C004-2000085-C',
'C004-2000087-B',
'C004-3000044-A',
'C004-3000085-C',
'C004-3000087-B',
'C004-4000044-A',
'C004-4000085-C',
'C004-4000087-B',
'C027-0000066-A',
'C027-9000139-A',
'D003-0000021-A',
'D003-0000004-B',
'D003-0000006-B',
'D003-0000052-D',
'D003-0000060-B',
'C004-1000014-A',
'C004-1000014-A',
'C004-1000033-A',
'C004-4000127-A',
'C004-4000129-A',
'C004-4000129-A',
'C004-4000185-A',
'C004-4000187-A',
'C004-4000187-A',
'C004-4000187-A',
'C004-4000190-A',
'C004-4000190-A',
'C004-4000190-A',
'C004-4000219-A',
'C004-4000221-A',
'C004-4000236-A',
'C004-4000248-A',
'C004-4000258-A',
'D016-0000020-A',
'D016-0000020-A',
'D016-0000020-A',
'D016-0000020-A',
'D016-0000020-A',
'D016-0000020-A',
'D016-0000021-A',
'D016-0000021-A',
'D016-0000022-A',
'D016-0000022-A',
'D016-0000022-A',
'D016-0000022-A',
'D016-0000023-A',
'D016-0000023-A',
'D016-0000027-A',
'D016-0000027-A',
'D016-0000028-A',
'D016-0000028-A',
'D016-0000031-A',
'D016-0000031-A',
'D016-0000031-A',
'D016-0000031-A',
'D016-0000033-A',
'D016-0000033-A',
'D016-0000036-A',
'D016-0000036-A',
'D016-0000039-A',
'D016-0000039-A',
'D016-0000041-A',
'D016-0000041-A',
'D016-0000041-A',
'D016-0000041-A',
'D016-0000041-A',
'D016-0000041-A',
'D016-0000044-A',
'D016-0000044-A',
'D15I-1000014-A',
'D15I-1000015-A',
'D15I-1000016-A',
'D15I-1000017-A',
'D15I-1000018-A',
'D15I-1000022-A',
'C004-1000001-A',
'C004-1000002-A',
'C020-0000132-B',
'C027-0000073-C',
'C027-0000095-A',
'C027-1000095-A',
'C027-1100095-A',
'C027-1200095-A',
'C027-1300095-A',
'C027-2000095-A',
'C027-3000095-A',
'C027-4000095-A',
'C027-5000095-A',
'C027-6000095-A',
'C027-7000095-A',
'C027-8000095-A',
'C027-9000095-A',
'D003-0000009-B',
'D003-0000045-B',
'D003-0000055-C',
'D15I-2000119-A',
'D15I-2000119-A',
'D15I-2000125-A',
'D15I-2000125-A',
'D15I-2000125-A',
'D15I-2000140-A',
'D15I-2000140-A',
'D15I-2000141-A',
'SD02-0000023-A',
'SD02-0000024-A',
'SD02-0000025-A',
'SD02-0000026-A',
'SD02-0000027-A',
'SD02-0000028-A',
'SD02-0000029-A',
'SD02-0000045-A',
'SD02-0000050-A',
'SD02-0000052-A',
'SD02-0000047-A',
'D15I-2000011-A',
'D15I-2000011-A',
'D15I-2000013-A',
'D15I-2000013-A',
'D15I-2000015-A',
'D15I-2000015-A',
'D15I-2000027-A',
'D15I-2000027-A',
'D15I-2000163-A',
'D15I-2000163-A',
'C007-0000025-A',
'C007-0000025-A',
'C007-0000029-A',
'C007-0000029-A',
'SD05-0000021-A',
'SD05-0000008-A',
'SD05-0000008-A',
'SD05-0000008-A',
'SD05-0000008-A',
'C006-0000024-A',
'C006-0000028-A',
'SD05-0000004-A',
'SD05-0000004-A',
'SD05-0000004-A',
'SD05-0000004-A',
'SD05-0000009-A',
'SD05-0000009-A',
'SD05-0000009-A',
'SD05-0000009-A',
'SD05-0000026-A',
'SD05-0000026-A',
'SD05-0000026-A',
'SD05-0000026-A',
'SD05-0000030-A',
'SD05-0000030-A',
'SD06-0000002-A',
'SD06-0000003-A',
'SD06-0000004-A',
'SD06-0000005-A',
'SD06-0000006-A',
'SD06-0000007-A',
'SD06-0000008-A',
'SD06-0000009-A',
'SD06-0000010-A',
'SD06-0000011-A',
'SD06-0000012-A',
'SD06-0000013-A',
'SD06-0000014-A',
'SD06-0000017-A',
'SD06-0000025-A',
'SD06-0000026-A',
'SD06-0000029-A',
'C027-0000136-A',
'D003-0000152-A',
'D003-0000152-A',
'',
'',
'',
'',
'',
'',
'D027-0000001-A',
'4-9729224',
'C003-1000030-A',
'C003-1000030-A',
'D024-0001266-A',
'D15N-1000002-A',
'D15N-1000011-A',
'D15N-1000011-A',
'D15N-1000011-A',
'D15N-1000011-A',
'D15N-1000013-A',
'D15N-1000013-A',
'D15N-1000013-A',
'D15N-1000013-A',
'D15N-1000014-A',
'D15N-1000014-A',
'D15N-1000014-A',
'D15N-1000014-A',
'C004-0000052-A',
'D15I-1000010-A',
'C004-1000003-A',
'C004-1000080-A',
'C004-1000080-A',
'C027-0000008-C',
'D003-0000148-A',
'D003-0000148-A',
'D15I-2000010-B',
'4-9071262',
'4-9071263',
'D016-0000053-A',
'SD02-0000012-A',
'SD02-0000036-A',
'SD02-0000037-A',
'SD02-0000048-A',
'C008-0000001-A',
'C008-0000007-A',
'CL03-0000004-A',
'SD01-0000001-A',
'SD01-0000002-A',
'C002-2000110-A',
'C002-2000111-A',
'C002-2000169-A',
'CL01-0000430-A',
'CL01-0000431-A',
'CL01-0000432-A',
'C004-0000125-A',
'C004-1000012-A',
'C004-1000125-A',
'C004-2000125-A',
'C004-3000125-A',
'C004-4000125-A',
'D003-0000001-B',
'D003-0000001-B',
'D003-0000005-B',
'D003-0000005-B',
'D003-0000024-A',
'D003-0000024-A',
'D003-0000025-A',
'D003-0000025-A',
'D003-0000026-A',
'D003-0000026-A',
'D003-0000027-A',
'D003-0000027-A',
'D003-0000029-C',
'D003-0000029-C',
'D003-0000030-A',
'D003-0000030-A',
'D003-0000031-A',
'D003-0000031-A',
'D003-0000053-D',
'D003-0000053-D',
'D003-0000061-A',
'D003-0000061-A',
'D003-0000065-A',
'D003-0000065-A',
'D003-0000074-A',
'D003-0000074-A',
'D003-0000036-B',
'D003-0000040-A',
'D003-0000041-B',
'D003-0000056-C',
'D003-0000057-A',
'D003-0000068-B',
'C004-0000010-A',
'C004-0000010-A',
'C004-0000064-A',
'C004-0000074-A',
'C004-0000122-A',
'C004-0000122-A',
'C004-0000122-A',
'C004-0000122-A',
'C004-1000011-A',
'C004-1000019-A',
'C004-1000039-A',
'C004-1000039-A',
'C004-1000039-A',
'C004-3000058-A',
'C004-4000058-A',
'C004-4000201-A',
'C020-0000069-B',
'D003-0000002-B',
'D003-0000002-B',
'D003-0000003-B',
'D003-0000003-B',
'D003-0000008-A',
'D003-0000011-A',
'D003-0000011-A',
'D003-0000012-A',
'D003-0000012-A',
'D003-0000013-A',
'D003-0000013-A',
'D003-0000014-A',
'D003-0000014-A',
'D003-0000015-A',
'D003-0000015-A',
'D003-0000016-A',
'D003-0000016-A',
'D003-0000018-A',
'D003-0000018-A',
'D003-0000019-A',
'D003-0000019-A',
'D003-0000022-A',
'D003-0000022-A',
'D003-0000023-A',
'D003-0000023-A',
'D003-0000032-A',
'D003-0000032-A',
'D003-0000033-A',
'D003-0000033-A',
'D003-0000035-E',
'D003-0000037-B',
'D003-0000037-B',
'D003-0000043-A',
'D003-0000043-A',
'D003-0000044-B',
'D003-0000044-B',
'D003-0000049-B',
'D003-0000049-B',
'D003-0000051-B',
'D003-0000051-B',
'D003-0000058-A',
'D003-0000058-A',
'D003-0000059-A',
'D003-0000059-A',
'D003-0000064-A',
'D003-0000064-A',
'D003-0000066-C',
'D003-0000066-C',
'D003-0000067-C',
'D003-0000067-C',
'D003-0000126-A',
'D003-0000201-A',
'D003-0000201-A',
'D023-0000105-A',
'D15I-1000011-A',
'D15I-1000011-A',
'D15I-1000011-A',
'D15I-1000012-A',
'D15I-1000012-A',
'D15I-1000012-A',
'D15I-1000013-A',
'D15I-1000013-A',
'D15I-1000013-A',
'D15I-2000039-A',
'D15I-2000039-A',
'D15I-2000107-A',
'D15I-2000110-A',
'D15I-2000116-A',
'D15I-2000116-A',
'D15I-2000116-A',
'D15I-2000116-A',
'D15I-2000116-A',
'D15I-2000220-A',
'C004-0000001-A',
'C004-0000002-B',
'C004-0000002-B',
'C004-0000041-A',
'C004-0000045-A',
'C004-0000045-A',
'C004-1000010-A',
'C004-4000265-A',
'C020-3000009-A',
'C020-3000010-A',
'D003-0000020-A',
'D003-0000039-A',
'D003-0000077-A',
'D15I-1000001-A',
'D15I-1000002-A',
'D003-0000042-A',
'D15I-1000019-A',
'D15I-1000020-A',
'D15I-1000021-A',
'C004-4000151-A',
'C004-4000151-A',
'C004-4000194-A',
'C004-4000194-A',
'C004-4000194-A',
'C004-4000244-A',
'D023-0000100-A',
'D023-0000100-A',
'D023-0000100-A',
'D023-0000100-A',
'D023-0000100-A',
'D023-0000100-A',
'D023-0000101-A',
'D023-0000102-A',
'D15I-2000104-A',
'D15I-2000104-A',
'D15I-2000104-A',
'SD02-0000096-A',
'SD02-0000097-A',
'SD02-0000098-A',
'SD02-0000099-A',
'SD02-0000105-A',
'4-9729222',
'4-9729223',
'C001-0000664-A',
'C001-1000627-A',
'C001-1000692-A',
'C001-2000001-A',
'C001-2000005-A',
'C001-2000006-A',
'C001-2000010-A',
'C001-2000013-A',
'C001-2000023-A',
'C001-2000023-A',
'C001-2000023-A',
'C001-2000024-A',
'C001-2000025-A',
'C001-2000025-A',
'C001-2000025-A',
'C001-2000026-A',
'C001-2000026-A',
'C001-2000026-A',
'C001-2000031-A',
'C001-2000031-A',
'C001-2000031-A',
'C001-2000032-A',
'C001-2000034-A',
'C001-2000035-A',
'C001-2000036-A',
'C001-2000044-A',
'C001-2000052-A',
'C001-2000052-A',
'C001-2000053-A',
'C001-2000054-A',
'C001-2000054-A',
'C001-2000055-A',
'C001-2000056-A',
'C001-2000062-A',
'C001-2000063-A',
'C001-2000064-A',
'C001-2000066-A',
'C001-2000066-A',
'C001-2000066-A',
'C001-2000067-A',
'C001-2000067-A',
'C001-2000067-A',
'C001-2000068-A',
'C001-2000069-A',
'C001-2000071-A',
'C001-2000071-A',
'C001-2000071-A',
'C001-2000072-A',
'C001-2000074-A',
'C001-2000074-A',
'C001-2000074-A',
'C001-2000075-A',
'C001-2000075-A',
'C001-2000075-A',
'C001-2000076-A',
'C001-2000076-A',
'C001-2000078-A',
'C001-2000081-A',
'C001-2000084-A',
'C001-2000084-A',
'C001-2000089-A',
'C001-2000090-A',
'C001-2000091-A',
'C001-2000092-A',
'C001-2000094-A',
'C001-2000095-A',
'C001-2000096-A',
'C001-2000097-A',
'C001-2000102-A',
'C001-2000102-A',
'C001-2000103-A',
'C001-2000103-A',
'C001-2000107-A',
'C001-2000108-A',
'C001-2000109-A',
'C001-2000109-A',
'C001-2000110-A',
'C001-2000111-A',
'C001-2000122-A',
'C001-2000126-A',
'C001-2000126-A',
'C002-0000126-A',
'C002-0000126-A',
'C002-0000152-A',
'C002-1000013-A',
'C002-1000014-A',
'C002-1000015-A',
'C002-1000017-A',
'C002-1000018-A',
'C002-1000019-A',
'C002-1000020-A',
'C002-1000021-A',
'C002-1000022-A',
'C002-1000023-A',
'C002-1000024-A',
'C002-1000025-A',
'C002-1000026-A',
'C002-1000035-A',
'C002-1000076-A',
'C002-1000076-A',
'CL01-0000328-A',
'CL01-0000335-A',
'CL01-0000336-A',
'CL01-0000337-A',
'CL01-0000338-A',
'CL01-0000339-A',
'CL01-0000340-A',
'CL01-0000341-A',
'CL01-0000343-A',
'CL01-0000344-A',
'CL01-0000345-A',
'CL01-0000346-A',
'CL01-0000347-A',
'CL01-0000347-A',
'CL01-0000348-A',
'CL01-0000349-A',
'CL01-0000361-A',
'CL01-0000364-A',
'CL01-0000365-A',
'CL01-0000366-A',
'CL01-0000368-A',
'CL01-0000385-A',
'CL01-0000386-A',
'CL01-0000422-A',
'CL01-0000427-A',
'CL01-0000427-A',
'CL01-1000439-A',
'CL01-1000492-A',
'CL01-1000538-A',
'CL01-1000787-A',
'CL01-1001732-A',
'CL01-1002519-A',
'CL01-1002522-A',
'CL01-1002526-A',
'CL01-1002533-A',
'CL01-1002572-A',
'CL01-1002578-A',
'CL01-1002580-A',
'CL01-1002587-A',
'CL01-1002588-A',
'CL01-1002592-A',
'CL01-1002595-A',
'CL01-1002599-A',
'CL01-1002665-A',
'CL01-1002673-A',
'CL01-1002674-A',
'CL01-1002678-A',
'CL01-1002679-A',
'CL01-1002682-A',
'CL01-1002689-A',
'CL01-1002695-A',
'CL01-1002701-A',
'CL01-1002704-A',
'CL01-1002707-A',
'CL01-1002714-A',
'CL01-1002763-A',
'D04N-1000001-A',
'SD05-0000016-A',
'SD05-0000017-A',
'SD05-0000017-A',
'SD05-0000017-A',
'SD05-0000017-A',
'SD05-0000019-A',
'SD05-0000019-A',
'SD05-0000019-A',
'SD05-0000019-A',
'SD05-0000022-A',
'SD05-0000022-A',
'SD05-0000023-A',
'SD05-0000023-A',
'SD05-0000023-A',
'SD05-0000023-A',
'SD05-0000024-A',
'SD05-0000024-A',
'SD05-0000024-A',
'SD05-0000024-A',
'SD05-0000031-A',
'SD05-0000031-A',
'SD05-0000032-A',
'SD05-0000032-A',
'SD06-0000015-A',
'SD06-0000018-A',
'SD06-0000019-A',
'SD06-0000020-A',
'SD06-0000021-A',
'SD06-0000022-A',
'SD06-0000023-A',
'SD06-0000024-A',
'SD06-0000027-A',
'SD06-0000028-A',
'SD06-0000031-A',
'SD06-0000032-A',
'SD06-0000033-A',
'SD06-0000034-A',
'SD06-0000035-A',
'SD06-0000036-A',
'SD06-0000037-A',
'SD05-0000003-A',
'SD05-0000003-A',
'SD05-0000003-A',
'SD05-0000003-A',
'C008-0000018-A',
'C008-0000018-A',
'C008-0000025-A',
'C008-0000025-A',
'C008-0000032-A',
'C008-0000032-A',
'C008-0000033-A',
'C008-0000033-A',
'CL03-0000011-A',
'CL03-0000011-A',
'CL03-0000016-A',
'CL03-0000023-A',
'CL03-0000026-A',
'CL03-0000028-A',
'CL03-0000034-A',
'C020-1000001-A',
'C020-1000001-A',
'SD02-0000004-A',
'SD02-0000005-A',
'SD02-0000006-A',
'SD02-0000030-A',
'SD02-0000031-A',
'SD05-0000002-A',
'SD05-0000002-A',
'SD05-0000002-A',
'SD05-0000002-A',
'SD05-0000007-A',
'SD05-0000007-A',
'SD05-0000007-A',
'SD05-0000007-A',
'SD05-0000010-A',
'SD05-0000010-A',
'SD05-0000010-A',
'SD05-0000010-A',
'SD05-0000018-A',
'SD05-0000018-A',
'SD05-0000027-A',
'SD05-0000027-A',
'SD05-0000027-A',
'SD05-0000027-A',
'SD05-0000029-A',
'SD05-0000029-A',
'SD06-0000000-A',
'SD06-0000001-A',
'SD06-0000016-A',
'SD02-0000019-A',
'SD02-0000020-A',
'SD02-0000021-A',
'SD02-0000038-A',
'SD02-0000039-A',
'SD02-0000040-A',
'SD02-0000100-A',
'SD02-0000101-A',
'SD02-0000101-A',
'SD02-0000103-A',
'SD02-0000104-A',
'SD02-0000106-A',
'SD02-0000107-A',
'SD02-0000108-A',
'SD02-0000109-A',
'SD02-0000110-A',
'SD02-0000111-A',
'C004-0000036-A',
'C004-0000044-A',
'C004-0000059-A',
'C004-0000087-B',
'C004-0000121-B',
'C004-0000127-A',
'C004-0000127-A',
'C004-1000044-A',
'C004-1000087-B',
'C004-2000044-A',
'C004-2000087-B',
'C004-3000044-A',
'C004-3000087-B',
'C004-4000044-A',
'C004-4000087-B',
'C027-0000003-A',
'C027-0000004-A',
'C027-0000005-A',
'C027-0000006-A',
'C027-0000047-A',
'C027-0000048-A',
'C027-0000049-A',
'C027-0000050-A',
'C027-0000054-A',
'C027-0000055-A',
'C027-0000057-A',
'C027-0000061-A',
'C027-0000079-B',
'C027-0000080-B',
'C027-0000088-A',
'C027-0000090-A',
'C027-0000091-B',
'C027-0000092-B',
'C027-0000096-A',
'C027-0000101-A',
'C027-0000120-A',
'C027-1000003-A',
'C027-1000061-A',
'C027-1000101-A',
'C027-1000120-A',
'C027-2000003-A',
'C027-2000061-A',
'C027-2000101-A',
'C027-2000120-A',
'C027-3000061-A',
'C027-3000101-A',
'C027-4000061-A',
'C027-4000101-A',
'C027-9000148-A',
'SD02-0000006-A',
'SD02-0000008-A',
'SD02-0000043-A',
'SD02-0000044-A',
'SD02-0000076-A',
'C006-0000008-A',
'C006-0000008-A',
'C007-0000009-A',
'C007-0000009-A',
'C007-0000012-A',
'C007-0000012-A',
'C026-0000017-A',
'C026-0000018-A',
'C026-0000019-A',
'C026-0000020-B',
'C026-0000021-B',
'C026-0000022-B',
'C026-0000023-B',
'C026-0000024-A',
'C026-0000025-A',
'C026-0000026-B',
'C026-0000027-B',
'C026-0000028-B',
'C026-0000029-A',
'C026-0000039-A',
'C026-0000040-A',
'C026-0000042-A',
'C026-0000043-A',
'C026-0000051-B',
'C026-0000053-A',
'C026-0000070-A',
'C026-0000071-A',
'C026-0000076-B',
'C026-0000077-B',
'C026-0000078-A',
'C026-0000083-A',
'C026-0000094-A',
'C026-0000097-A',
'C026-0000097-A',
'C026-0000097-A',
'C026-0000098-A',
'C026-0000098-A',
'C026-0000099-A',
'C026-0000099-A',
'C026-0000102-A',
'C026-0000102-A',
'C026-0000103-A',
'C026-0000103-A',
'C026-0000104-A',
'C026-0000104-A',
'C026-0000105-A',
'C026-0000105-A',
'C026-0000106-B',
'C026-0000106-B',
'C026-0000107-B',
'C026-0000107-B',
'C026-0000108-A',
'C026-0000108-A',
'C026-0000109-A',
'C026-0000109-A',
'C026-0000109-A',
'C026-0000110-A',
'C026-0000110-A',
'C026-0000111-A',
'C026-0000111-A',
'C026-0000111-A',
'C026-0000113-A',
'C026-0000113-A',
'C026-0000114-A',
'C026-0000114-A',
'C026-0000115-B',
'C026-0000115-B',
'C026-0000116-B',
'C026-0000116-B',
'C026-0000117-B',
'C026-0000117-B',
'C026-0000118-B',
'C026-0000118-B',
'C026-0000128-A',
'C026-0000128-A',
'C026-0000129-A',
'C026-0000129-A',
'C026-0000130-A',
'C026-0000130-A',
'C026-0000131-A',
'C026-0000131-A',
'C026-0000132-A',
'C026-0000133-A',
'C026-0000133-A',
'C026-0000134-A',
'C026-0000134-A',
'C026-0000135-A',
'C026-0000136-A',
'C026-0000137-A',
'C026-0000138-A',
'C026-1000039-A',
'C026-1000040-A',
'C026-1000042-A',
'C026-1000043-A',
'C026-1000076-B',
'C026-1000077-B',
'C026-1000078-A',
'C026-1000083-A',
'C026-1000094-A',
'C026-1000099-A',
'C026-1000099-A',
'C026-2000040-A',
'C026-2000042-A',
'C026-2000043-A',
'C026-2000076-B',
'C026-2000077-B',
'C026-2000078-A',
'C026-2000083-A',
'C026-2000094-A',
'C026-3000040-A',
'C026-3000042-A',
'C026-3000043-A',
'C026-3000077-B',
'C026-3000078-A',
'C026-3000083-A',
'C026-3000094-A',
'C026-4000040-A',
'C026-4000077-B',
'C026-4000078-A',
'C026-4000083-A',
'C026-4000094-A',
'C026-5000040-A',
'C026-5000077-B',
'C026-5000078-A',
'C026-5000083-A',
'C026-5000094-A',
'C026-6000040-A',
'C026-6000083-A',
'C026-7000040-A',
'C026-7000083-A',
'C026-8000083-A',
'C026-9000083-A',
'D15I-2000001-A',
'D15I-2000020-A',
'D15I-2000022-A',
'D15I-2000033-A',
'D15I-2000100-A',
'D15I-2000100-A',
'D15I-2000171-A',
'C007-0000001-A',
'C007-0000001-A',
'C007-0000002-A',
'C007-0000003-A',
'C007-0000037-A',
'C007-0000037-A',
'SD02-0000042-A',
'SD05-0000005-A',
'SD05-0000005-A',
'SD05-0000005-A',
'SD05-0000005-A',
'SD05-0000006-A',
'SD05-0000006-A',
'SD05-0000006-A',
'SD05-0000006-A',
'SD05-0000020-A',
'SD05-0000020-A',
'SD05-0000020-A',
'SD05-0000020-A',
'SD05-0000028-A',
'SD05-0000028-A',
'C027-9000133-A',
'SD05-0000011-A',
'SD05-0000012-A',
'SD05-0000013-A',
'SD05-0000014-A',
'SD05-0000015-A',
'SD05-0000025-A',
'SD06-0000030-A',
'C020-1000002-A',
'C020-1000002-A',
'C020-1000002-A',
'C020-3000001-A',
'C020-3000001-A',
'C020-3000001-A',
'C001-2000130-A',
'C001-2000133-A',
'C001-2000134-A',
'C001-2000136-A',
'C001-2000140-A',
'C001-2000143-A',
'C001-2000147-A',
'C001-2000149-A',
'D026-0000001-A',
'D026-0000001-A',
'D15N-1000021-A',
'D15N-1000022-A',
'D15N-1000028-A',
'V002-0000001-A',
'V002-0000001-A',
'C004-1000004-A',
'C004-1000005-A',
'C004-1000012-A',
'C004-1000012-A',
'C020-0000135-A',
'D003-0000028-A',
'D003-0000063-A',
'D003-0000072-A',
'D003-0000072-A',
'D003-0000072-A',
'D003-0000072-A',
'D15I-1000003-A',
'D15I-1000003-A',
'D15I-1000003-A',
'D15I-1000009-A',
'D15I-2000004-A',
'D15I-2000004-A',
'D15I-2000004-A',
'D15I-2000004-A',
'D15I-2000004-A',
'D15I-2000005-A',
'D15I-2000005-A',
'D15I-2000005-A',
'D15I-2000006-A',
'D15I-2000006-A',
'D15I-2000007-A',
'D15I-2000007-A',
'CL01-000999-A',
'4-9708980',
'4-9708980',
'4-9708982',
'4-9709063',
'4-9719068',
'4-9719068',
'C001-1000696-A',
'C001-2000015-A',
'C001-2000016-A',
'C001-2000016-A',
'C001-2000017-A',
'C001-2000018-A',
'C001-2000019-A',
'C001-2000020-A',
'C001-2000021-A',
'C001-2000022-A',
'C001-2000027-A',
'C001-2000027-A',
'C001-2000033-A',
'C001-2000037-A',
'C001-2000037-A',
'C001-2000038-A',
'C001-2000038-A',
'C001-2000039-A',
'C001-2000039-A',
'C001-2000040-A',
'C001-2000040-A',
'C001-2000041-A',
'C001-2000041-A',
'C001-2000042-A',
'C001-2000042-A',
'C001-2000047-A',
'C001-2000047-A',
'C001-2000048-A',
'C001-2000048-A',
'C001-2000051-A',
'C001-2000057-A',
'C001-2000057-A',
'C001-2000057-A',
'C001-2000057-A',
'C001-2000058-A',
'C001-2000058-A',
'C001-2000059-A',
'C001-2000059-A',
'C001-2000060-A',
'C001-2000060-A',
'C001-2000061-A',
'C001-2000061-A',
'C001-2000065-A',
'C001-2000065-A',
'C001-2000070-A',
'C001-2000070-A',
'C001-2000077-A',
'C001-2000077-A',
'C001-2000079-A',
'C001-2000079-A',
'C001-2000080-A',
'C001-2000080-A',
'C001-2000082-A',
'C001-2000082-A',
'C001-2000083-A',
'C001-2000085-A',
'C001-2000085-A',
'C001-2000085-A',
'C001-2000087-A',
'C001-2000087-A',
'C001-2000100-A',
'C001-2000100-A',
'C001-2000101-A',
'C001-2000101-A',
'C001-2000104-A',
'C001-2000104-A',
'C001-2000105-A',
'C001-2000105-A',
'C001-2000117-A',
'C001-2000119-A',
'C002-0000003-A',
'C002-0000005-A',
'C002-0000006-A',
'C002-0000006-A',
'C002-0000012-A',
'C002-0000020-A',
'C002-0000020-A',
'C002-0000022-A',
'C002-0000026-A',
'C002-0000027-A',
'C002-0000028-A',
'C002-0000029-A',
'C002-0000030-A',
'C002-0000031-A',
'C002-0000032-A',
'C002-0000033-A',
'C002-0000034-A',
'C002-0000035-A',
'C002-0000036-A',
'C002-0000037-A',
'C002-0000038-A',
'C002-0000039-A',
'C002-0000040-A',
'C002-0000041-A',
'C002-0000042-A',
'C002-0000043-A',
'C002-0000044-A',
'C002-0000045-A',
'C002-0000047-A',
'C002-0000049-A',
'C002-0000050-A',
'C002-0000051-A',
'C002-0000051-A',
'C002-0000051-A',
'C002-0000052-A',
'C002-0000053-A',
'C002-0000053-A',
'C002-0000057-A',
'C002-0000058-A',
'C002-0000059-A',
'C002-0000060-A',
'C002-0000061-A',
'C002-0000067-A',
'C002-0000069-A',
'C002-0000070-A',
'C002-0000071-A',
'C002-0000073-A',
'C002-0000075-A',
'C002-0000077-A',
'C002-0000084-A',
'C002-0000084-A',
'C002-0000086-A',
'C002-0000087-A',
'C002-0000090-A',
'C002-0000093-A',
'C002-0000094-A',
'C002-0000095-A',
'C002-0000096-A',
'C002-0000097-A',
'C002-0000099-A',
'C002-0000100-A',
'C002-0000101-A',
'C002-0000102-A',
'C002-0000103-A',
'C002-0000104-A',
'C002-0000108-A',
'C002-0000109-A',
'C002-0000110-A',
'C002-0000111-A',
'C002-0000118-A',
'C002-0000118-A',
'C002-0000120-A',
'C002-1000001-A',
'C002-1000002-A',
'C002-1000003-A',
'C002-1000004-A',
'C002-1000004-A',
'C002-1000005-A',
'C002-1000005-A',
'C002-1000005-A',
'C002-1000006-A',
'C002-1000006-A',
'C002-1000006-A',
'C002-1000007-A',
'C002-1000007-A',
'C002-1000008-A',
'C002-1000009-A',
'C002-1000010-A',
'C002-1000011-A',
'C002-1000012-A',
'C002-1000016-A',
'C002-1000016-A',
'C002-1000027-A',
'C002-1000027-A',
'C002-1000028-A',
'C002-1000028-A',
'C002-1000029-A',
'C002-1000030-A',
'C002-1000031-A',
'C002-1000031-A',
'C002-1000032-A',
'C002-1000033-A',
'C002-1000034-A',
'C002-1000036-A',
'C002-1000037-A',
'C002-1000037-A',
'C002-1000038-A',
'C002-1000038-A',
'C002-1000039-A',
'C002-1000039-A',
'C002-1000040-A',
'C002-1000041-A',
'C002-1000041-A',
'C002-1000042-A',
'C002-1000043-A',
'C002-1000043-A',
'C002-1000043-A',
'C002-1000044-A',
'C002-1000045-A',
'C002-1000046-A',
'C002-1000046-A',
'C002-1000047-A',
'C002-1000047-A',
'C002-1000048-A',
'C002-1000048-A',
'C002-1000049-A',
'C002-1000050-A',
'C002-1000051-A',
'C002-1000052-A',
'C002-1000053-A',
'C002-1000053-A',
'C002-1000054-A',
'C002-1000054-A',
'C002-1000055-A',
'C002-1000055-A',
'C002-1000056-A',
'C002-1000056-A',
'C002-1000057-A',
'C002-1000058-A',
'C002-1000059-A',
'C002-1000060-A',
'C002-1000060-A',
'C002-1000061-A',
'C002-1000062-A',
'C002-1000062-A',
'C002-1000063-A',
'C002-1000064-A',
'C002-1000065-A',
'C002-1000065-A',
'C002-1000066-A',
'C002-1000067-A',
'C002-1000068-A',
'C002-1000069-A',
'C002-1000070-A',
'C002-1000071-A',
'C002-1000072-A',
'C002-1000072-A',
'C002-1000073-A',
'C002-1000073-A',
'C002-1000073-A',
'C002-1000074-A',
'C002-1000075-A',
'C002-1000077-A',
'C002-1000077-A',
'C002-1000078-A',
'C002-1000078-A',
'C002-1000079-A',
'C002-1000080-A',
'C002-1000081-A',
'C002-1000082-A',
'C002-1000082-A',
'C002-1000083-A',
'C002-1000083-A',
'C002-1000083-A',
'C002-2000027-A',
'C002-2000028-A',
'C002-2000047-A',
'C002-2000049-A',
'C002-2000090-A',
'C002-2000109-A',
'C002-2000112-A',
'C002-2000117-A',
'C002-2000117-A',
'C002-2000177-A',
'C003-1000001-A',
'C003-1000001-A',
'C003-1000002-A',
'C003-1000002-A',
'C003-1000006-A',
'C003-1000007-A',
'C003-1000008-A',
'C003-1000009-A',
'C003-1000010-A',
'C003-1000011-A',
'C011-1000003-A',
'C011-1000003-A',
'C011-1000003-A',
'C011-1000003-A',
'C011-1000005-A',
'C011-1000005-A',
'C011-1000005-A',
'C011-1000009-A',
'C011-1000009-A',
'C011-1000012-A',
'C011-1000012-A',
'C011-1000012-A',
'C011-1000013-A',
'C011-1000014-A',
'C011-1000015-A',
'C011-1000015-A',
'C011-1000016-A',
'C011-1000056-A',
'C011-1000056-A',
'C011-1000056-A',
'C011-1000071-A',
'CL01-0000001-A',
'CL01-00000010-A',
'CL01-000000100-A',
'CL01-000000100-A',
'CL01-000000100-A',
'CL01-000000101-A',
'CL01-000000101-A',
'CL01-000000101-A',
'CL01-000000102-A',
'CL01-000000102-A',
'CL01-000000102-A',
'CL01-000000103-A',
'CL01-000000104-A',
'CL01-000000105-A',
'CL01-000000106-A',
'CL01-000000106-A',
'CL01-000000107-A',
'CL01-000000107-A',
'CL01-000000108-A',
'CL01-000000108-A',
'CL01-000000108-A',
'CL01-000000109-A',
'CL01-000000109-A',
'CL01-000000109-A',
'CL01-00000011-A',
'CL01-000000110-A',
'CL01-000000110-A',
'CL01-000000110-A',
'CL01-000000111-A',
'CL01-000000111-A',
'CL01-000000111-A',
'CL01-000000112-A',
'CL01-000000112-A',
'CL01-000000112-A',
'CL01-000000113-A',
'CL01-000000113-A',
'CL01-000000113-A',
'CL01-000000114-A',
'CL01-000000114-A',
'CL01-000000114-A',
'CL01-000000115-A',
'CL01-000000115-A',
'CL01-000000115-A',
'CL01-000000116-A',
'CL01-000000116-A',
'CL01-000000116-A',
'CL01-000000117-A',
'CL01-000000117-A',
'CL01-000000117-A',
'CL01-000000118-A',
'CL01-000000118-A',
'CL01-000000118-A',
'CL01-000000119-A',
'CL01-000000119-A',
'CL01-00000012-A',
'CL01-000000120-A',
'CL01-000000120-A',
'CL01-000000120-A',
'CL01-000000121-A',
'CL01-000000122-A',
'CL01-000000123-A',
'CL01-000000124-A',
'CL01-000000124-A',
'CL01-000000125-A',
'CL01-000000125-A',
'CL01-000000126-A',
'CL01-000000126-A',
'CL01-000000127-A',
'CL01-000000127-A',
'CL01-000000128-A',
'CL01-000000128-A',
'CL01-000000128-A',
'CL01-000000129-A',
'CL01-000000129-A',
'CL01-00000013-A',
'CL01-000000130-A',
'CL01-000000130-A',
'CL01-000000131-A',
'CL01-000000131-A',
'CL01-000000131-A',
'CL01-000000132-A',
'CL01-000000132-A',
'CL01-000000133-A',
'CL01-000000133-A',
'CL01-000000134-A',
'CL01-000000134-A',
'CL01-000000135-A',
'CL01-000000135-A',
'CL01-000000136-A',
'CL01-000000136-A',
'CL01-000000137-A',
'CL01-000000138-A',
'CL01-000000139-A',
'CL01-000000139-A',
'CL01-00000014-A',
'CL01-000000140-A',
'CL01-000000140-A',
'CL01-000000141-A',
'CL01-000000141-A',
'CL01-000000142-A',
'CL01-000000143-A',
'CL01-000000143-A',
'CL01-000000144-A',
'CL01-000000144-A',
'CL01-000000144-A',
'CL01-000000145-A',
'CL01-000000145-A',
'CL01-000000146-A',
'CL01-000000146-A',
'CL01-000000147-A',
'CL01-000000148-A',
'CL01-000000149-A',
'CL01-000000149-A',
'CL01-00000015-A',
'CL01-000000150-A',
'CL01-000000150-A',
'CL01-000000151-A',
'CL01-000000151-A',
'CL01-000000152-A',
'CL01-000000153-A',
'CL01-000000153-A',
'CL01-000000154-A',
'CL01-000000154-A',
'CL01-000000154-A',
'CL01-000000155-A',
'CL01-000000155-A',
'CL01-000000156-A',
'CL01-000000157-A',
'CL01-000000158-A',
'CL01-000000159-A',
'CL01-000000159-A',
'CL01-00000016-A',
'CL01-00000016-A',
'CL01-000000160-A',
'CL01-000000160-A',
'CL01-000000160-A',
'CL01-000000161-A',
'CL01-000000161-A',
'CL01-000000161-A',
'CL01-000000162-A',
'CL01-000000162-A',
'CL01-000000162-A',
'CL01-000000163-A',
'CL01-000000163-A',
'CL01-000000163-A',
'CL01-000000164-A',
'CL01-000000165-A',
'CL01-000000166-A',
'CL01-000000166-A',
'CL01-000000167-A',
'CL01-000000167-A',
'CL01-000000168-A',
'CL01-000000168-A',
'CL01-00000017-A',
'CL01-000000171-A',
'CL01-000000171-A',
'CL01-000000173-A',
'CL01-000000173-A',
'CL01-000000173-A',
'CL01-000000174-A',
'CL01-000000174-A',
'CL01-000000174-A',
'CL01-000000175-A',
'CL01-000000176-A',
'CL01-000000176-A',
'CL01-000000176-A',
'CL01-000000177-A',
'CL01-000000177-A',
'CL01-000000178-A',
'CL01-000000178-A',
'CL01-000000179-A',
'CL01-000000179-A',
'CL01-00000018-A',
'CL01-000000180-A',
'CL01-000000180-A',
'CL01-000000181-A',
'CL01-000000181-A',
'CL01-000000182-A',
'CL01-000000182-A',
'CL01-000000183-A',
'CL01-000000183-A',
'CL01-000000184-A',
'CL01-000000185-A',
'CL01-000000186-A',
'CL01-000000187-A',
'CL01-000000187-A',
'CL01-000000188-A',
'CL01-000000189-A',
'CL01-00000019-A',
'CL01-000000190-A',
'CL01-000000191-A',
'CL01-000000192-A',
'CL01-000000193-A',
'CL01-000000193-A',
'CL01-000000193-A',
'CL01-000000194-A',
'CL01-000000194-A',
'CL01-000000194-A',
'CL01-000000195-A',
'CL01-000000195-A',
'CL01-000000195-A',
'CL01-000000196-A',
'CL01-000000197-A',
'CL01-000000198-A',
'CL01-000000199-A',
'CL01-000000199-A',
'CL01-00000020-A',
'CL01-000000200-A',
'CL01-000000200-A',
'CL01-000000200-A',
'CL01-000000201-A',
'CL01-000000201-A',
'CL01-000000202-A',
'CL01-000000202-A',
'CL01-000000202-A',
'CL01-000000203-A',
'CL01-000000203-A',
'CL01-000000204-A',
'CL01-000000204-A',
'CL01-000000205-A',
'CL01-000000205-A',
'CL01-000000206-A',
'CL01-000000207-A',
'CL01-000000208-A',
'CL01-000000209-A',
'CL01-00000021-A',
'CL01-00000021-A',
'CL01-00000021-A',
'CL01-000000210-A',
'CL01-000000211-A',
'CL01-000000212-A',
'CL01-000000213-A',
'CL01-000000213-A',
'CL01-000000213-A',
'CL01-000000214-A',
'CL01-000000214-A',
'CL01-000000214-A',
'CL01-000000215-A',
'CL01-000000215-A',
'CL01-000000215-A',
'CL01-000000216-A',
'CL01-000000216-A',
'CL01-000000216-A',
'CL01-000000217-A',
'CL01-000000217-A',
'CL01-000000218-A',
'CL01-000000218-A',
'CL01-000000219-A',
'CL01-000000219-A',
'CL01-00000022-A',
'CL01-000000220-A',
'CL01-000000220-A',
'CL01-000000221-A',
'CL01-000000221-A',
'CL01-000000222-A',
'CL01-000000222-A',
'CL01-000000223-A',
'CL01-000000223-A',
'CL01-000000224-A',
'CL01-000000224-A',
'CL01-000000225-A',
'CL01-000000225-A',
'CL01-000000226-A',
'CL01-000000226-A',
'CL01-000000227-A',
'CL01-000000227-A',
'CL01-000000228-A',
'CL01-000000228-A',
'CL01-000000229-A',
'CL01-000000229-A',
'CL01-00000023-A',
'CL01-000000230-A',
'CL01-000000230-A',
'CL01-000000231-A',
'CL01-000000231-A',
'CL01-000000231-A',
'CL01-000000231-A',
'CL01-000000231-A',
'CL01-000000231-A',
'CL01-000000231-A',
'CL01-000000231-A',
'CL01-000000231-A',
'CL01-000000231-A',
'CL01-000000232-A',
'CL01-000000232-A',
'CL01-000000233-A',
'CL01-000000233-A',
'CL01-000000233-A',
'CL01-000000234-A',
'CL01-000000234-A',
'CL01-000000234-A',
'CL01-000000235-A',
'CL01-000000235-A',
'CL01-000000235-A',
'CL01-000000236-A',
'CL01-000000236-A',
'CL01-000000236-A',
'CL01-000000237-A',
'CL01-000000237-A',
'CL01-000000237-A',
'CL01-000000238-A',
'CL01-000000238-A',
'CL01-000000238-A',
'CL01-000000239-A',
'CL01-000000239-A',
'CL01-000000239-A',
'CL01-00000024-A',
'CL01-000000240-A',
'CL01-000000240-A',
'CL01-000000240-A',
'CL01-000000241-A',
'CL01-000000241-A',
'CL01-000000241-A',
'CL01-000000242-A',
'CL01-000000242-A',
'CL01-000000242-A',
'CL01-000000243-A',
'CL01-000000243-A',
'CL01-000000243-A',
'CL01-000000244-A',
'CL01-000000244-A',
'CL01-000000244-A',
'CL01-000000245-A',
'CL01-000000245-A',
'CL01-000000245-A',
'CL01-000000246-A',
'CL01-000000246-A',
'CL01-000000246-A',
'CL01-000000247-A',
'CL01-000000247-A',
'CL01-000000247-A',
'CL01-000000248-A',
'CL01-000000248-A',
'CL01-000000248-A',
'CL01-000000249-A',
'CL01-000000249-A',
'CL01-000000249-A',
'CL01-00000025-A',
'CL01-000000250-A',
'CL01-000000250-A',
'CL01-000000250-A',
'CL01-000000251-A',
'CL01-000000251-A',
'CL01-000000251-A',
'CL01-000000252-A',
'CL01-000000252-A',
'CL01-000000252-A',
'CL01-00000026-A',
'CL01-00000027-A',
'CL01-00000028-A',
'CL01-00000029-A',
'CL01-00000030-A',
'CL01-00000031-A',
'CL01-00000032-A',
'CL01-00000033-A',
'CL01-00000034-A',
'CL01-00000035-A',
'CL01-00000036-A',
'CL01-00000037-A',
'CL01-00000038-A',
'CL01-00000039-A',
'CL01-0000004-A',
'CL01-00000040-A',
'CL01-00000040-A',
'CL01-00000041-A',
'CL01-00000042-A',
'CL01-00000042-A',
'CL01-00000043-A',
'CL01-00000043-A',
'CL01-00000044-A',
'CL01-00000045-A',
'CL01-00000045-A',
'CL01-00000046-A',
'CL01-00000046-A',
'CL01-00000047-A',
'CL01-00000047-A',
'CL01-00000048-A',
'CL01-00000048-A',
'CL01-00000049-A',
'CL01-00000049-A',
'CL01-0000005-A',
'CL01-00000050-A',
'CL01-00000051-A',
'CL01-00000052-A',
'CL01-00000053-A',
'CL01-00000053-A',
'CL01-00000054-A',
'CL01-00000054-A',
'CL01-00000055-A',
'CL01-00000055-A',
'CL01-00000056-A',
'CL01-00000056-A',
'CL01-00000057-A',
'CL01-00000057-A',
'CL01-00000058-A',
'CL01-00000058-A',
'CL01-00000059-A',
'CL01-00000059-A',
'CL01-0000006-A',
'CL01-00000060-A',
'CL01-00000060-A',
'CL01-00000061-A',
'CL01-00000061-A',
'CL01-00000062-A',
'CL01-00000062-A',
'CL01-00000063-A',
'CL01-00000063-A',
'CL01-00000064-A',
'CL01-00000064-A',
'CL01-00000065-A',
'CL01-00000065-A',
'CL01-00000066-A',
'CL01-00000066-A',
'CL01-00000067-A',
'CL01-00000068-A',
'CL01-00000069-A',
'CL01-0000007-A',
'CL01-00000070-A',
'CL01-00000071-A',
'CL01-00000072-A',
'CL01-00000073-A',
'CL01-00000073-A',
'CL01-00000074-A',
'CL01-00000074-A',
'CL01-00000074-A',
'CL01-00000075-A',
'CL01-00000076-A',
'CL01-00000077-A',
'CL01-00000078-A',
'CL01-00000079-A',
'CL01-0000008-A',
'CL01-00000080-A',
'CL01-00000081-A',
'CL01-00000082-A',
'CL01-00000083-A',
'CL01-00000084-A',
'CL01-00000084-A',
'CL01-00000085-A',
'CL01-00000086-A',
'CL01-00000087-A',
'CL01-00000088-A',
'CL01-00000089-A',
'CL01-0000009-A',
'CL01-00000090-A',
'CL01-00000091-A',
'CL01-00000092-A',
'CL01-00000093-A',
'CL01-00000094-A',
'CL01-00000095-A',
'CL01-00000096-A',
'CL01-00000097-A',
'CL01-00000098-A',
'CL01-00000099-A',
'CL01-00000099-A',
'CL01-00000099-A',
'CL01-00000100-A',
'CL01-0000210-A',
'CL01-0000433-A',
'CL01-0000434-A',
'CL01-0000435-A',
'CL01-0000437-A',
'CL01-0000438-A',
'CL01-0000440-A',
'CL01-0000441-A',
'CL01-0000442-A',
'CL01-0000443-A',
'CL01-0000444-A',
'CL01-0000445-A',
'CL01-0000446-A',
'CL01-0000447-A',
'CL01-0000448-A',
'CL01-0000449-A',
'CL01-0000450-A',
'CL01-0000451-A',
'CL01-0000452-A',
'CL01-1000001-A',
'CL01-1000001-A',
'CL01-1000001-A',
'CL01-1000002-A',
'CL01-1000002-A',
'CL01-1000002-A',
'CL01-1000003-A',
'CL01-1000003-A',
'CL01-1000003-A',
'CL01-1000005-A',
'CL01-1000005-A',
'CL01-1000005-A',
'CL01-1000006-A',
'CL01-1000006-A',
'CL01-1000006-A',
'CL01-1000007-A',
'CL01-1000007-A',
'CL01-1000007-A',
'CL01-1000008-A',
'CL01-1000008-A',
'CL01-1001326-A',
'CL01-1001867-A',
'CL01-1001873-A',
'CL01-1001874-A',
'CL01-1001880-A',
'CL01-1001883-A',
'CL01-1001887-A',
'CL01-1001889-A',
'CL01-1001896-A',
'CL01-1001898-A',
'CL01-1001901-A',
'CL01-1001906-A',
'CL01-1001910-A',
'CL01-1001915-A',
'CL01-1001920-A',
'CL01-1001923-A',
'CL01-1001925-A',
'CL01-1001927-A',
'CL01-1001933-A',
'CL01-1001939-A',
'CL01-1002009-A',
'CL01-1002012-A',
'CL01-1002019-A',
'CL01-1002029-A',
'CL01-1002029-A',
'CL01-1002036-A',
'CL01-1002036-A',
'CL01-1002036-A',
'CL01-1002037-A',
'CL01-1002041-A',
'CL01-1002043-A',
'CL01-1002048-A',
'CL01-1002055-A',
'CL01-1002058-A',
'CL01-1002061-A',
'CL01-1002064-A',
'CL01-1002068-A',
'CL01-1002074-A',
'CL01-1002076-A',
'CL01-1002081-A',
'CL01-1002088-A',
'CL01-1002094-A',
'CL01-1002175-A',
'CL01-1002178-A',
'CL01-1002178-A',
'CL01-1002178-A',
'CL01-1002179-A',
'CL01-1002179-A',
'CL01-1002180-A',
'CL01-1002180-A',
'CL01-1002186-A',
'CL01-1002192-A',
'CL01-1002199-A',
'CL01-1002202-A',
'CL01-1002205-A',
'CL01-1002208-A',
'CL01-1002215-A',
'CL01-1002220-A',
'CL01-1002224-A',
'CL01-1002231-A',
'CL01-1002233-A',
'CL01-1002236-A',
'CL01-1002237-A',
'CL01-1002243-A',
'CL01-1002245-A',
'CL01-1002246-A',
'CL01-1002246-A',
'CL01-1002246-A',
'CL01-1002248-A',
'CL01-1003532-A',
'D15N-1000001-A',
'D15N-1000003-A'
);

  FOR i IN my_services.FIRST .. my_services.LAST
  LOOP
--    DBMS_OUTPUT.PUT_LINE('Processing serviceNumber['||i||']: '||my_services(i));

    errorMsg  := null;
    found     := 0;
    
    BEGIN 
      FOR s IN serviceData(my_services(i)) LOOP
        BEGIN
          found := 1;
          DBMS_OUTPUT.PUT_LINE(s.serviceData);
        EXCEPTION
          WHEN others THEN
            errorMsg := substr(sqlerrm, 1, 1000);
            DBMS_OUTPUT.PUT_LINE('ERROR ---> '||my_services(i)||':'||errorMsg);
        END;
      END LOOP;
      
      IF(found = 0) THEN
        DBMS_OUTPUT.PUT_LINE('ERROR ---> '||my_services(i)||': NO RECORD FOUND');
      END IF;
      
    EXCEPTION
      WHEN others THEN
        errorMsg := substr(sqlerrm, 1, 1000);
        DBMS_OUTPUT.PUT_LINE('ERROR ---> GENERIC ERROR: '||errorMsg);
    END;
    
  END LOOP;

END;