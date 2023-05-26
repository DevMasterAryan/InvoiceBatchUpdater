# config/initializers/sidekiq.rb
require 'pg'

Thread.new do
  connection = PG.connect(dbname: 'InvoiceBatchUpdater_development')
  connection.exec("LISTEN invoice_line_item_change")

  loop do
    connection.wait_for_notify do |channel, _pid, payload|
      payload_data = JSON.parse(payload)
      invoice_batch_id = payload_data['invoice_batch_id']
      InvoiceBatchUpdateJob.perform_now(invoice_batch_id)
    end
  end
end
