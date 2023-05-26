# spec/jobs/invoice_batch_update_job_spec.rb
require 'rails_helper'

RSpec.describe InvoiceBatchUpdateJob, type: :job do
  describe '#perform' do
    it 'updates the corresponding invoice batch' do
      invoice_line_item = InvoiceLineItem.create(amount: 100)  # Create a new invoice line item
      invoice_batch = InvoiceBatch.create(name: 'Sample Invoice Batch')  # Create a new invoice batch

      invoice_line_item.update(invoice_batch: invoice_batch)  # Associate the invoice line item with the invoice batch

      described_class.perform_now(invoice_line_item)

      invoice_batch.reload  # Reload the invoice batch from the database

      expect(invoice_batch.total_amount).to eq(100)  # Assert that the invoice batch is updated with the correct total amount
    end
  end
end
