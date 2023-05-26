# spec/models/invoice_line_item_spec.rb
require 'rails_helper'

RSpec.describe InvoiceLineItem, type: :model do
  describe 'after_commit callback' do
    let(:invoice_batch) { create(:invoice_batch) }
    let(:invoice_line_item) { build(:invoice_line_item, invoice_batch: invoice_batch) }

    context 'when a new invoice line item is created' do
      it 'enqueues the InvoiceBatchUpdateJob' do
        expect {
          invoice_line_item.save
        }.to have_enqueued_job(InvoiceBatchUpdateJob).on_queue('default')
      end

      it 'enqueues the job with the correct arguments' do
        expect {
          invoice_line_item.save
        }.to have_enqueued_job(InvoiceBatchUpdateJob).with(invoice_line_item)
      end
    end

    context 'when an invoice line item is updated' do
      it 'enqueues the InvoiceBatchUpdateJob' do
        invoice_line_item.save

        expect {
          invoice_line_item.update(amount: 100)
        }.to have_enqueued_job(InvoiceBatchUpdateJob).on_queue('default')
      end

      it 'enqueues the job with the correct arguments' do
        invoice_line_item.save

        expect {
          invoice_line_item.update(amount: 100)
        }.to have_enqueued_job(InvoiceBatchUpdateJob).with(invoice_line_item)
      end
    end

  end
end
