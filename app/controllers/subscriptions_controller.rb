class SubscriptionsController < ApplicationController

  before_filter :authenticate_user!, only: [:edit, :update]

  skip_before_filter :verify_authenticity_token, only: [:create], if: :paypal?

  def new
    @upgrade_user = params[:user_id]
    @sponsorship = @upgrade_user && current_user.try(:id) != @upgrade_user
    render plan_name
  end

  def edit
  end

  def upgrade
    customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
    subscription = customer.subscriptions.retrieve(customer.subscriptions.first.id)
    subscription.plan = "premiumplus"
    subscription.save
    current_user.subscription.type = 'PremiumPlus'
    current_user.save
  rescue Stripe::StripeError => e
    flash[:error] = e.message
    redirect_to user_path(current_user)
  end

  def create
    @user = detect_user
    @plan = detect_plan
    @sponsored_user = sponsored_user?

    create_stripe_customer unless paypal?

    update_user_to_premium(@user)
    send_acknowledgement_email

  rescue StandardError => e
    flash[:error] = e.message
    redirect_to new_subscription_path
  end

  def update
    customer = Stripe::Customer.retrieve(current_user.stripe_customer_id) # _token?
    card = customer.sources.create(card: stripe_token(params))
    card.save
    customer.default_card = card.id
    customer.save
  rescue Stripe::StripeError, NoMethodError => e
    logger.error "Stripe error while updating card info: #{e.message} for #{current_user}"
    @error = true
  end

  private

  def detect_plan
    return Plan.new params['item_name'].downcase if paypal?
    Plan.new params[:plan]
  end

  def detect_user
    slug = paypal? ? params['item_number'] : params[:user]
    User.find_by(slug: slug)
  end

  def paypal?
    params['item_number']
  end

  def create_stripe_customer
    @stripe_customer = Stripe::Customer.create(
        email: params[:stripeEmail],
        source: stripe_token(params),
        plan: @plan.plan_id
    )
  end

  def sponsored_user?
    @user.present? && current_user != @user
  end

  def stripe_token(params)
    Rails.env.test? ? generate_test_token : params[:stripeToken]
  end

  def generate_test_token
    StripeMock.create_test_helper.generate_card_token
  end

  def update_user_to_premium(user)
    user ||= current_user
    return unless user
    if paypal?
      UpgradeUserToPremium.with(user, Time.now, params['payer_id'], PaymentSource::PayPal, plan_class)
    else
      UpgradeUserToPremium.with(user, Time.now, @stripe_customer.id, PaymentSource::Stripe, plan_class)
    end
  end

  def plan_name
    return 'premium_mob' if params[:plan] == 'premiummob'
    return 'premium_f2f' if params[:plan] == 'premiumf2f'
    return 'premium_plus' if params[:plan] == 'premiumplus'
    'premium'
  end

  def plan_class
    return PremiumF2F if params[:plan] == 'premiumf2f'
    plan_name.camelcase.constantize
  end

  def send_acknowledgement_email
    payer_email = paypal? ? params['payer_email'] : params[:stripeEmail]
    if sponsored_user?
      Mailer.send(sponsor_acknowledgement_email_template, @user.email, payer_email).deliver_now
    else
      Mailer.send(acknowledgement_email_template, payer_email).deliver_now
    end
  end

  def sponsor_acknowledgement_email_template
    "send_sponsor_#{plan_name}_payment_complete".to_sym
  end

  def acknowledgement_email_template
    "send_#{plan_name}_payment_complete".to_sym
  end
end

class Plan
  attr_reader :plan_id

  def initialize(plan_id)
    @plan_id = plan_id
  end

  def to_s
    PLANS[plan_id]
  end

  def free_trial?
    plan_id == 'premium'
  end

  private

  PLANS = {
      'premium' => 'Premium',
      'premiummob' => 'Premium Mob',
      'premiumf2f' => 'Premium F2F',
      'premiumplus' => 'Premium Plus'
  }
end
