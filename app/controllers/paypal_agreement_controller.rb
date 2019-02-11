class PaypalAgreementController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @plan = Plan.find(params[:plan])
    session.delete(:user)
    session[:user] = params[:user] if params[:user]
    if (@agreement = new_paypal_agreement).error.nil?
      @redirect_url = @agreement.links.find { |v| v.method == 'REDIRECT' }.href
      respond_to do |format|
        format.json { render json: { redirect_url: @redirect_url } }
      end
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
                                                   user: session[:user],
                                                   format: :json
  rescue StandardError => e
    flash[:error] = e.message
    respond_to do |format|
      format.json { render json: { error: e.message } }
    end
  end

  private
  
  def new_paypal_agreement
    PaypalService.new.create_agreement(@plan.paypal_id)
  end
end
