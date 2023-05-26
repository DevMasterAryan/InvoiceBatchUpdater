# spec/factories.rb
FactoryBot.define do
  factory :invoice_batch do
    # Define attributes for your factory
    # Example:
    name { 'Sample Invoice Batch' }
    # Other attributes...
  end

  factory :invoice_line_item do
  	amount {100}
  end
end
