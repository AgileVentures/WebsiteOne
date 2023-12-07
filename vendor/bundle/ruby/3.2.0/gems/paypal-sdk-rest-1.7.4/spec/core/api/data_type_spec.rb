require 'spec_helper'

describe PayPal::SDK::Core::API::DataTypes::Base do

  DataType = PayPal::SDK::Core::API::DataTypes::Base

  class TestCurrency < DataType

    # Members
    object_of :amount, String
    object_of :desciption, String, :namespace => "ns"
    # Attributes
    add_attribute :currencyID, :namespace => "cc"
  end

  class TestType < DataType
    object_of :fromCurrency, TestCurrency
    array_of  :toCurrency,   TestCurrency
    object_of :firstname,    String, :name => "first-name"
  end

  class TestSimpleType < DataType
    include PayPal::SDK::Core::API::DataTypes::SimpleTypes
    object_of :created_on, Date
    object_of :created_at, DateTime
  end

  class Message < DataType
    object_of :value, String
  end

  it "should allow content key" do
    message = Message.new("Testing message")
    expect(message.value).to eql "Testing message"

    message = Message.new(:value => "Testing message")
    expect(message.value).to eql "Testing message"
  end

  it "should create member object automatically" do
    test_type = TestType.new
    expect(test_type.fromCurrency).to   be_a TestCurrency
    expect(test_type.toCurrency).to     be_a Array
    expect(test_type.toCurrency[0]).to  be_a TestCurrency
    expect(test_type.toCurrency[1]).to  be_a TestCurrency
    expect(test_type.toCurrency[0].amount).to eql nil
    expect(test_type.fromCurrency.amount).to  eql nil
    expect(test_type.fromCurrency.desciption).to    eql nil
    expect(test_type.fromCurrency.currencyID).to    eql nil
  end

  it "should convert the given data to configured type" do
    test_type = TestType.new( :fromCurrency => { :currencyID => "USD", :amount => "50.0"})
    expect(test_type.fromCurrency).to be_a TestCurrency
    expect(test_type.fromCurrency.currencyID).to    eql "USD"
    expect(test_type.fromCurrency.amount).to  eql "50.0"
  end

  it "invoice address loads all members of default address object" do
    invoice_address = InvoiceAddress.new(:line1 => "line1", :line2 => "line2", :phone => { :country_code => "123", :national_number => "1231231234", :extension => "123" }, :status => "status" )
    expect(invoice_address).to be_a InvoiceAddress
    expect(invoice_address.phone).to be_a Phone
    expect(invoice_address.line1).to eql "line1"
    expect(invoice_address.line2).to eql "line2"
    expect(invoice_address.status).to eql "status"
    expect(invoice_address.phone.country_code).to eql "123"
    expect(invoice_address.phone.national_number).to eql "1231231234"
    expect(invoice_address.phone.extension).to eql "123"
  end

  it "billing info converts an address to invoiceaddress automatically" do
    address = Address.new(:line1 => "line1", :line2 => "line2", :status => "status" )
    billing_info = BillingInfo.new({
      :first_name => "Sally",
      :last_name => "Patient",
      :business_name => "Not applicable",
    })
    billing_info.address = address
    expect(billing_info.address).to be_a Address
    expect(billing_info.invoice_address).to be_a InvoiceAddress
  end

  it "shipping info returns an Address even if set to InvoiceAddress for backwards compatibility" do
    address = InvoiceAddress.new(:line1 => "line1", :line2 => "line2", :status => "status", :phone => { :national_number => "1234567890" } )
    billing_info = BillingInfo.new({
      :first_name => "Sally",
      :last_name => "Patient",
      :business_name => "Not applicable",
    })
    billing_info.address = address
    expect(billing_info.address).to be_a Address
    expect(billing_info.invoice_address).to be_a InvoiceAddress
    expect(billing_info.invoice_address.phone.national_number).to eql "1234567890"
  end

  it "returns the address and invoice address types in the billing info" do
    billing_info = BillingInfo.new({
      "first_name" => "Sally",
      "last_name" => "Patient",
      "business_name" => "Not applicable",
      "address" => {
        "line1" => "line1Value",
        "phone" => { "country_code" => "123", "national_number" => "1234567890", "extension" => "456" },
      },
    })
    expect(billing_info.address).to be_a Address
    expect(billing_info.address.line1).to eql "line1Value"
    expect(billing_info.invoice_address).to be_a InvoiceAddress
    expect(billing_info.invoice_address.line1).to eql "line1Value"
    expect(billing_info.invoice_address.phone.country_code).to eql "123"
    expect(billing_info.invoice_address.phone.national_number).to eql "1234567890"
    expect(billing_info.invoice_address.phone.extension).to eql "456"
  end

  it "shipping info converts an address to invoiceaddress automatically" do
    address = Address.new(:line1 => "line1", :line2 => "line2", :status => "status" )
    shipping_info = ShippingInfo.new({
      "first_name" => "Sally",
      "last_name" => "Patient",
      "business_name" => "Not applicable",
    })
    shipping_info.address = address
    expect(shipping_info.address).to be_a Address
    expect(shipping_info.invoice_address).to be_a InvoiceAddress
  end

  it "shipping info returns an Address even if set to InvoiceAddress for backwards compatibility" do
    address = InvoiceAddress.new(:line1 => "line1", :line2 => "line2", :status => "status", :phone => { :national_number => "1234567890" } )
    shipping_info = ShippingInfo.new({
      "first_name" => "Sally",
      "last_name" => "Patient",
      "business_name" => "Not applicable",
    })
    shipping_info.address = address
    expect(shipping_info.address).to be_a Address
    expect(shipping_info.invoice_address).to be_a InvoiceAddress
    expect(shipping_info.invoice_address.phone.national_number).to eql "1234567890"
  end

  it "returns the address and invoice address types in the shipping info" do
    shipping_info = ShippingInfo.new({
      "first_name" => "Sally",
      "last_name" => "Patient",
      "business_name" => "Not applicable",
      "address" => {
        "line1" => "line1Value",
        "phone" => { "country_code" => "123", "national_number" => "1234567890", "extension" => "456" },
      },
    })
    expect(shipping_info.address).to be_a Address
    expect(shipping_info.address.line1).to eql "line1Value"
    expect(shipping_info.invoice_address).to be_a InvoiceAddress
    expect(shipping_info.invoice_address.line1).to eql "line1Value"
    expect(shipping_info.invoice_address.phone.country_code).to eql "123"
    expect(shipping_info.invoice_address.phone.national_number).to eql "1234567890"
    expect(shipping_info.invoice_address.phone.extension).to eql "456"
  end

  it "should allow block with initializer" do
    test_type = TestType.new do
      fromCurrency do
        self.currencyID = "USD"
        self.amount = "50.0"
      end
    end
    expect(test_type.fromCurrency.currencyID).to    eql "USD"
    expect(test_type.fromCurrency.amount).to  eql "50.0"
  end

  it "should allow block with member" do
    test_type = TestType.new
    test_type.fromCurrency do
      self.currencyID = "USD"
      self.amount = "50.0"
    end
    expect(test_type.fromCurrency.currencyID).to    eql "USD"
    expect(test_type.fromCurrency.amount).to  eql "50.0"
  end

  it "should assign value to attribute" do
    test_currency = TestCurrency.new( :@currencyID => "USD", :amount => "50" )
    expect(test_currency.currencyID).to eql "USD"
  end

  it "should allow configured Class object" do
    test_currency = TestCurrency.new( :currencyID => "USD", :amount => "50" )
    test_type = TestType.new( :fromCurrency => test_currency )
    expect(test_type.fromCurrency).to eql test_currency
  end

  it "should allow snakecase" do
    test_type = TestType.new( :from_currency => {} )
    expect(test_type.from_currency).to be_a TestCurrency
    expect(test_type.from_currency).to eql test_type.fromCurrency
  end

  it "should allow array" do
    test_type = TestType.new( :toCurrency => [{ :currencyID => "USD", :amount => "50.0" }] )
    expect(test_type.toCurrency).to be_a Array
    expect(test_type.toCurrency.first).to be_a TestCurrency
    expect(test_type.toCurrency.first.currencyID).to eql "USD"
  end

  it "should skip undefind members on initializer" do
    test_type = TestType.new( :notExist => "testing")
    expect do
      test_type.notExist
    end.to raise_error NoMethodError
    expect do
      test_type.notExist = "Value"
    end.to raise_error NoMethodError
  end

  it "should not convert empty hash" do
    test_type = TestType.new( :fromCurrency => {} )
    expect(test_type.to_hash).to eql({})
  end

  it "should not convert empty array" do
    test_type = TestType.new( :toCurrency => [] )
    expect(test_type.to_hash).to eql({})
  end

  it "should not convert array of empty hash" do
    test_type = TestType.new( :toCurrency => [ {} ] )
    expect(test_type.to_hash).to eql({})
  end

  it "should return empty hash" do
    test_type = TestType.new
    expect(test_type.to_hash).to eql({})
  end

  it "should convert to hash" do
    test_currency = TestCurrency.new(:amount => "500")
    expect(test_currency.to_hash).to eql("amount" => "500")
  end

  it "should convert to hash with key as symbol" do
    test_currency = TestCurrency.new(:amount => "500")
    expect(test_currency.to_hash(:symbol => true)).to eql(:amount => "500")
  end

  it "should convert attribute key with @" do
    test_currency = TestCurrency.new( :currencyID => "USD", :amount => "50" )
    expect(test_currency.to_hash["@currencyID"]).to eql "USD"
  end

  it "should convert attribute key without @" do
    test_currency = TestCurrency.new( :currencyID => "USD", :amount => "50" )
    expect(test_currency.to_hash(:attribute => false)["currencyID"]).to eql "USD"
  end

  it "should convert to hash with namespace" do
    test_currency = TestCurrency.new(:currencyID => "USD", :amount => "500", :desciption => "Testing" )
    hash = test_currency.to_hash
    expect(hash["amount"]).to eql "500"
    expect(hash["ns:desciption"]).to eql "Testing"
    expect(hash["@currencyID"]).to eql "USD"
    hash = test_currency.to_hash(:namespace => false)
    expect(hash["amount"]).to eql "500"
    expect(hash["desciption"]).to eql "Testing"
    expect(hash["@currencyID"]).to eql "USD"
  end

  it "should allow namespace" do
    test_currency = TestCurrency.new(:amount => "500", :"ns:desciption" => "Testing" )
    expect(test_currency.desciption).to eql "Testing"
  end

  it "should use name option in members" do
    test_type = TestType.new( :firstname => "FirstName")
    expect(test_type.to_hash).to eql({"first-name" => "FirstName" })
  end

  it "should allow date" do
    date_time = "2010-10-10T10:10:10"
    test_simple_type = TestSimpleType.new( :created_on => date_time, :created_at => date_time )
    expect(test_simple_type.created_on).to be_a Date
    expect(test_simple_type.created_at).to be_a DateTime
  end

  it "should allow date with value 0" do
    test_simple_type = TestSimpleType.new( :created_at => "0" )
    expect(test_simple_type.created_at).to be_a DateTime
  end

end

