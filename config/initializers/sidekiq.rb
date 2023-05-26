# config/initializers/sidekiq.rb
require 'pg'

Thread.new do
  connection = PG.connect(dbname: 'InvoiceBatchUpdater_development')
  connection.exec("LISTEN invoice_line_item_change")

  loop do
    connection.wait_for_notify do |channel, _pid, payload|
      payload_data = JSON.parse(payload)
      invoice_batch_id = payload_data['invoice_batch_id']

      invoice_batch = InvoiceBatch.find_by(id: invoice_batch_id)
      next unless invoice_batch

      invoice_line_item = InvoiceLineItem.find_by(invoice_batch_id: invoice_batch_id)
      next unless invoice_line_item

      InvoiceBatchUpdateJob.perform_later(invoice_line_item)
    end
  end
end
