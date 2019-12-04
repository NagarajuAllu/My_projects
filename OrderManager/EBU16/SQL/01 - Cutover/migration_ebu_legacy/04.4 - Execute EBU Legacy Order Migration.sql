set serveroutput on

exec legacy_order_migration.migrate_all_legacy_orders;
