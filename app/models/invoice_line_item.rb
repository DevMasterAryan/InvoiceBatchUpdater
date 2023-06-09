class InvoiceLineItem < ApplicationRecord
  belongs_to :invoice_batch, optional: true
  after_commit :enqueue_invoice_batch_update, on: [:create, :update, :destroy]

  private

  def enqueue_invoice_batch_update
    InvoiceBatchUpdateJob.perform_now(self.invoice_batch_id)
  end
end