# frozen_string_literal: true

class Paypal
  def initialize(token, email, payer_id, payment_method, plan, user)
    @payer_id = payer_id
    @plan = plan
    @email = email
    @payment_method = payment_method
    @token = token
    @user = user
  end

  def url_params
    "token=#{@token}&email=#{@email}&payer_id=#{@payer_id}&payment_method=#{@payment_method}&plan=#{@plan}&user=#{@user}"
  end
end
