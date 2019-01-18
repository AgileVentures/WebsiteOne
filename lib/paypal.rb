class Paypal
  def initialize(item_number, item_name, payer_email)
    @item_number = item_number
    @item_name = item_name
    @payer_email = payer_email
  end

  def url_params
    "item_number=#{@item_number}&item_name=#{@item_name}&payer_email=#{@payer_email}"
  end    
end