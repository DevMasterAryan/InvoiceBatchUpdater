class InvoiceBatch < ApplicationRecord
  has_many :invoice_line_items

  def update_batch
    self.total_amount = invoice_line_items.sum(:amount)
    save
  end
end
