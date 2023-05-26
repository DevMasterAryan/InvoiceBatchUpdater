class InvoiceBatchUpdateJob < ApplicationJob
  queue_as :default

  def perform(invoice_line_item)
    invoice_batch = invoice_line_item.invoice_batch
    return unless invoice_batch

    invoice_batch.update(total_amount: invoice_batch.invoice_line_items.sum(:amount))
  end
end
