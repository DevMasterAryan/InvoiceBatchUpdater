# CREATE OR REPLACE FUNCTION notify_data_change() RETURNS TRIGGER AS $$
# BEGIN
#   INSERT INTO data_changes (table_name, record_id, created_at, updated_at)
#   VALUES (TG_TABLE_NAME, NEW.id, NOW(), NOW());

#   PERFORM pg_notify('data_change_notification', json_build_object('table_name', TG_TABLE_NAME, 'record_id', NEW.id)::TEXT);

#   RETURN NEW;
# END;
# $$ LANGUAGE plpgsql;

# CREATE TRIGGER data_change_trigger
# AFTER INSERT OR UPDATE OR DELETE ON invoice_line_items
# FOR EACH ROW
# EXECUTE FUNCTION notify_data_change();