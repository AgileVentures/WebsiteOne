# frozen_string_literal: true

class PaypalAgreementController < ApplicationController
  def new
    @plan = Plan.find(params[:plan])
    session.delete(:user)
    session[:user] = params[:user] if params[:user]
    if (@agreement = new_paypal_agreement).error.nil?
      @redirect_url = @agreement.links.detect { |v| v.method == 'REDIRECT' }.href
      redirect_to @redirect_url
    else
      @message = @agreement.error
    end
  end

  def create
    @executed_agreement = PaypalService.execute_agreement(params[:token])
    redirect_to subscriptions_paypal_redirect_path payment_method: @executed_agreement.payer.payment_method,
                                                   payer_id: @executed_agreement.payer.payer_info.payer_id,
                                                   plan: params[:plan],
                                                   email: @executed_agreement.payer.payer_info.email,
                                                   user: session[:user]
  rescue StandardError => e
    flash[:error] = e.message
    redirect_to new_subscription_path(plan: (@plan.try(:third_party_identifier) || 'premium'))
  end

  private

  def new_paypal_agreement
    PaypalService.new(@plan).create_agreement
  end
end
