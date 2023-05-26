class CreateInvoiceBatches < ActiveRecord::Migration[7.0]
  def change
    create_table :invoice_batches do |t|
      t.string :name
      t.decimal :total_amount
      t.timestamps
    end
  end
end
