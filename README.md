# Invoice Batch Updater

This Rails application demonstrates a solution for updating an invoice batch whenever a change is made to the amount of an invoice line item in the database. The solution utilizes PostgreSQL, Sidekiq, and Active Job to asynchronously process the updates.

## Requirements

- Ruby 3.0 or later
- PostgreSQL
- Sidekiq
- RSpec (for running tests)

## Setup

1. Clone the repository and navigate to the project directory:
2. Install dependencies:
3. Set up the database:

## Usage

1. Start the Sidekiq server with redis:


3. Access the application in your browser at `http://localhost:3000/sidekiq`.

4. Create and manage invoices and invoice line items through psql cli interface or using rails console.

## Implementation Details

### Database Trigger

- A database trigger has been added to the `invoice_line_items` table to send notifications when changes occur. The trigger function, `notify_invoice_line_item_change()`, sends a notification through the `invoice_line_item_change` channel. It includes the `invoice_batch_id` as payload.

- To listen for these notifications and enqueue the `InvoiceBatchUpdateJob`, the Sidekiq initializer (`config/initializers/sidekiq.rb`) includes code that establishes a connection to the database, sets up the listener, and processes the notifications in a separate thread.

### InvoiceBatchUpdateJob

- The `InvoiceBatchUpdateJob` is an Active Job that performs the actual update of the associated invoice batch. It retrieves the necessary records based on the `InvoiceLineItem` provided as an argument and recalculates the total amount for the invoice batch.

- The job is enqueued after the creation, update, or deletion of an `InvoiceLineItem` record, either through direct changes or by triggering the database trigger.

## Testing

RSpec tests have been provided to ensure the functionality of the invoice batch updater. To run the tests, execute the following command:

