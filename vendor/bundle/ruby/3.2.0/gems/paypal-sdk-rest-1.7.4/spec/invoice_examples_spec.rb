require "spec_helper"

describe "Invoice", :integration => true do

  InvoiceAttributes = {
    "merchant_info" => {
      "email" => "jaypatel512-facilitator@hotmail.com"
    },
    "billing_info" => [ { "email" => "example@example.com" } ],
    "items" => [
      {
        "name" => "Sutures",
        "quantity" => 100,
        "unit_price" => {
          "currency" => "USD",
          "value" => 5
        }
      }
    ],
    "note" => "Medical Invoice 16 Jul, 2013 PST"
  }

  it "create invoice" do
    invoice = PayPal::SDK::REST::Invoice.new(InvoiceAttributes)
    expect(invoice.create).to be_truthy
  end

  it "list invoice" do
    history = PayPal::SDK::REST::Invoice.get_all( :total_count_required =>true )
    expect(history.total_count).not_to be_nil
  end

  it "get invoice" do
    invoice = PayPal::SDK::REST::Invoice.find("INV2-6KYE-67GV-8AJR-SAER")
    expect(invoice).to be_a PayPal::SDK::REST::Invoice
    expect(invoice.id).to eql "INV2-6KYE-67GV-8AJR-SAER"
  end
end
