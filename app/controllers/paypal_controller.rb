class PaypalController < ApplicationController
  def new
    @upgrade_user = params[:user_id]
    @sponsorship = @upgrade_user && current_user.try(:id) != @upgrade_user
    @plan = detect_plan_before_payment
  end

  def subscribe
    @plan = Plan.find(params[:plan])
    if (@payment = new_paypal_service).error.nil?
      @redirect_url = @payment.links.find { |v| v.method == 'REDIRECT' }.href
      redirect_to @redirect_url
    else
      @message = @payment.error
    end
  end

  def execute
    @user = detect_user
    @plan = detect_plan_after_payment
    @sponsored_user = sponsored_user?

    @executed_agreement = execute_recurring_payment(params[:token])
    add_appropriate_subscription(@user, current_user)
    Vanity.track!(:premium_signups)
    
    send_acknowledgement_email
    
  rescue StandardError => e
    flash[:error] = e.message
    redirect_to new_subscription_path(plan: (@plan.try(:third_party_identifier) || 'premium'))
  end

  private

  def detect_plan_before_payment
    Plan.find_by(third_party_identifier: params[:plan]) || default_plan
  rescue ActiveRecord::NotFound
    default_plan
  end

  def new_paypal_service
    PaypalService.new.create_agreement(@plan.paypal_id)
  end

  def execute_recurring_payment(agreement_token)
    PaypalService.execute_agreement(agreement_token)
  end

  def detect_user
    id = @upgrade_user ? @upgrade_user.id : current_user.id
    User.find(id)
  end

  def detect_plan_after_payment
    Plan.find_by(third_party_identifier: params[:plan])
  end

  def sponsored_user?
    @user.present? && current_user != @user
  end

  def add_appropriate_subscription(user, sponsor = user)
    user ||= current_user
    return unless user

    payment_source = PaymentSource::PayPal.new identifier: params['payer_id']
    AddSubscriptionToUserForPlan.with(user, sponsor, Time.now, @plan, payment_source)
  end

  def send_acknowledgement_email
    payer_email = @executed_agreement.payer.payer_info.email 
    if sponsored_user?
      Mailer.send_sponsor_premium_payment_complete(@user.email, payer_email).deliver_now
    else
      Mailer.send_premium_payment_complete(@plan, payer_email).deliver_now
    end
  end
end
