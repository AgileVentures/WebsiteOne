class PaypalAgreementController < ApplicationController
  before_action :authenticate_user!, only: [:new]
  
  def new
    @plan = Plan.find(params[:plan])
    session.delete(:user)
    cookies[:user_id] = current_user.id if current_user
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
    binding.pry
    @executed_agreement = PaypalService.execute_agreement(params[:token])
    @user = detect_user
    @plan = detect_plan_after_payment
    @sponsored_user = sponsored_user?
    add_appropriate_subscription(@user, current_user)
    send_acknowledgement_email
    # redirect_to subscriptions_paypal_redirect_path payment_method: @executed_agreement.payer.payment_method, 
    #                                                payer_id: @executed_agreement.payer.payer_info.payer_id, 
    #                                                plan: params[:plan],
    #                                                email: @executed_agreement.payer.payer_info.email,
    #                                                user: session[:user]
  rescue StandardError => e
    flash[:error] = e.message
    redirect_to new_subscription_path(plan: (@plan.try(:third_party_identifier) || 'premium'))
  end

  private
  
  def new_paypal_agreement
    PaypalService.new.create_agreement(@plan.paypal_id)
  end

  def detect_user
    id = session[:user_id]
    User.find(id)
  end

  def detect_plan_after_payment
    id = params[:plan]
    Plan.find_by(third_party_identifier: id)
  end

  def sponsored_user?
    @user.present? && current_user != @user
  end

  def add_appropriate_subscription(user, sponsor = user)
    user ||= current_user
    return unless user

    payment_source = PaymentSource::PayPal.new identifier: params[:payer_id]

    AddSubscriptionToUserForPlan.with(user, sponsor, Time.now, @plan, payment_source)
  end

  def send_acknowledgement_email
    payer_email = params[:email]
    if sponsored_user?
      Mailer.send_sponsor_premium_payment_complete(@user.email, payer_email).deliver_now
    else
      Mailer.send_premium_payment_complete(@plan, payer_email).deliver_now
    end
  end
end
