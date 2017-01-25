class SubscriptionsController < ApplicationController

  before_filter :authenticate_user!, only: [:edit, :update]

  skip_before_filter :verify_authenticity_token, only: [:create], if: :paypal?

  def new
    @upgrade_user = params[:user_id]
    @sponsorship = @upgrade_user && current_user.try(:id) != @upgrade_user
    @plan = detect_plan_before_payment
  end

  def upgrade
    customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
    subscription = customer.subscriptions.retrieve(customer.subscriptions.first.id)
    subscription.plan = "premiummob"
    subscription.save
    current_user.subscription.plan = Plan.find_by third_party_identifier: 'premiummob'
    current_user.save
  rescue Stripe::StripeError => e
    flash[:error] = e.message
    redirect_to user_path(current_user)
  end

  def create
    @user = detect_user
    @plan = detect_plan_after_payment
    @sponsored_user = sponsored_user?

    create_stripe_customer unless paypal?

    add_appropriate_subscription(@user)
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

  def default_plan
    Plan.find_by(third_party_identifier: 'premium')
  end

  def detect_plan_after_payment
    id = paypal? ? params['item_name'].downcase.delete(' ') : params[:plan]
    Plan.find_by(third_party_identifier: id)
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
        plan: @plan.third_party_identifier
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

  def add_appropriate_subscription(user)
    user ||= current_user
    return unless user

    if paypal?
      payment_source = PaymentSource::PayPal.new identifier: params['payer_id']
    else
      payment_source = PaymentSource::Stripe.new identifier: @stripe_customer.id
    end

    AddSubscriptionToUserForPlan.with(user, Time.now, @plan, payment_source)
  end

  def send_acknowledgement_email
    payer_email = paypal? ? params['payer_email'] : params[:stripeEmail]
    if sponsored_user?
      Mailer.send_sponsor_premium_payment_complete(@user.email, payer_email).deliver_now
    else
      Mailer.send_premium_payment_complete(@plan, payer_email).deliver_now
    end
  end

end