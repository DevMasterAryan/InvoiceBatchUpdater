class CreateInvoiceLineItems < ActiveRecord::Migration[7.0]
  def change
    create_table :invoice_line_items do |t|
      t.decimal :amount
      t.integer :invoice_batch_id

      t.timestamps
    end
  end
end
