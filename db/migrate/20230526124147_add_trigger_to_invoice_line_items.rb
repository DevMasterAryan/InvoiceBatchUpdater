class AddTriggerToInvoiceLineItems < ActiveRecord::Migration[7.0]
  def up
    execute <<~SQL
      CREATE OR REPLACE FUNCTION notify_invoice_line_item_change() RETURNS TRIGGER AS $$
      DECLARE
        invoice_batch_id INTEGER;
      BEGIN
        IF TG_OP = 'DELETE' THEN
          invoice_batch_id := OLD.invoice_batch_id;
        ELSE
          invoice_batch_id := NEW.invoice_batch_id;
        END IF;
        
        PERFORM pg_notify('invoice_line_item_change', json_build_object('invoice_batch_id', invoice_batch_id)::TEXT);
        RETURN NULL;
      END;
      $$ LANGUAGE plpgsql;

      DROP TRIGGER IF EXISTS invoice_line_item_change_trigger ON invoice_line_items;
      CREATE TRIGGER invoice_line_item_change_trigger
      AFTER INSERT OR UPDATE OR DELETE ON invoice_line_items
      FOR EACH ROW
      EXECUTE FUNCTION notify_invoice_line_item_change();
    SQL
  end

  def down
    execute <<~SQL
      DROP TRIGGER IF EXISTS invoice_line_item_change_trigger ON invoice_line_items;
      DROP FUNCTION IF EXISTS notify_invoice_line_item_change();
    SQL
  end
end
