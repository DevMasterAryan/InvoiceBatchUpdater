require 'rails_helper'

RSpec.describe InvoiceLineItem, type: :model do
  describe "after_commit callback" do
    let(:invoice_line_item) { create(:invoice_line_item) }

    it "enqueues the InvoiceBatchUpdateJob" do
      expect(InvoiceBatchUpdateJob).to receive(:perform_now).with(invoice_line_item.invoice_batch_id)
      invoice_line_item.save
    end
  end
end
