class SubscriptionsController < ApplicationController

  before_filter :authenticate_user!, only: [:edit, :update]

  def new
    render plan_name
  end

  def paypal
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
    @user = User.find_by_slug(params[:user])
    @plan = Plan.new params[:plan]
    @sponsored_user = sponsored_user?

    update_user_to_premium(create_customer, @user)
    send_acknowledgement_email

  rescue Stripe::StripeError => e
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

  def create_customer
    Stripe::Customer.create(
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

  def update_user_to_premium(stripe_customer, user_for_update)
    user_for_update ||= current_user
    return unless user_for_update
    UpgradeUserToPremium.with(user_for_update, Time.now, stripe_customer.id, PaymentSource::Stripe, plan_class)
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
    Mailer.send(acknowledgement_email_template, params[:stripeEmail]).deliver_now
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
