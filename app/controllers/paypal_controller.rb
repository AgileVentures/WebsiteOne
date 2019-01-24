class PaypalController < ApplicationController
  def checkout
    if (@payment = new_paypal_service).error.nil?
      @redirect_url = @payment.links.find { |v| v.method == 'REDIRECT' }.href
      redirect_to @redirect_url
    else
      @message = @payment.error
    end
  end

  def execute
    @payment = execute_recurring_payment(params[:token])
  end
  
  private

  def new_paypal_service
    PaypalService.new.create_recurring_agreement
  end

  def execute_recurring_payment(agreement_token)
    PaypalService.execute_agreement(agreement_token)
  end
end