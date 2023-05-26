class InvoiceBatchUpdateJob < ApplicationJob
  queue_as :default

  def perform(invoice_batch_id)
    invoice_batch = InvoiceBatch.find_by(id: invoice_batch_id)
    return unless invoice_batch
    invoice_batch.update_batch
  end
end
