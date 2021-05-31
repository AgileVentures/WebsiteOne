# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  before_action :store_user_location!, if: :storable_location?
  before_action :authenticate_user!, if: :require_login?
  # skip_before_action :verify_authenticity_token, only: [:create], if: :paypal?

  def new
    @sponsee_slug = params[:user_id]
    @sponsorship = @sponsee_slug && current_user.try(:id) != @sponsee_slug
    @plan = detect_plan_before_payment
  end

  def create
    @sponsee = detect_user
    @plan = detect_plan_after_payment
    @is_sponsorship = is_sponsorship?

    create_stripe_customer unless paypal?

    add_appropriate_subscription(@sponsee, current_user)
    Vanity.track!(:premium_signups)
    send_acknowledgement_email
  rescue StandardError => e
    flash[:error] = e.message
    redirect_to new_subscription_path(plan: (@plan.try(:third_party_identifier) || 'premium'))
  end

  def update
    # "user_slug"=>"<slug>", "subscription"=>{"plan_id"=>"12"},
    # "commit"=>"Adjust Level", "controller"=>"subscriptions", "action"=>"update", "id"=>"45"} permitted: false>
    begin
      plan = Plan.find params[:subscription][:plan_id]
    rescue StandardError
      plan = Plan.find_by(third_party_identifier: 'premiummob')
    end

    user = if current_user.is_privileged? && params[:user_slug]
             User.find_by slug: params[:user_slug]
           else
             current_user
           end
    # so we have multiple cases here
    # 1. existing sponsor has already paid and is adding additional upgrade - below code would work
    # 2. user has paid for their own premium, and upgrades themselves - below code is good
    # 3. current_user paying for upgrade is different from user who paid for initial premium - will either fail or update incorrectly
    # 4. sponsor is sponsoring multiple different users - will update incorrectly

    # have adjusted presentation logic to only show the button to upgrade the subscription if the
    # user themselves actually paid for the original premium plan

    change_plan_through_stripe(user, plan)
  rescue Stripe::InvalidRequestError => e
    logger.error "Failing plan upgrade through Stripe: #{e.message}"
    flash[:error] =
      "We're sorry but we can't automatically upgrade your plan at this time. Please email info@agileventures.org to receive an upgrade"
    redirect_to user_path(current_user)
  rescue Stripe::StripeError => e
    # nil customer id will lead to Stripe::InvalidRequestError
    flash[:error] = e.message
    redirect_to user_path(current_user)
  rescue StandardError => e
    logger.error "Failing plan upgrade through Stripe: #{e.message}"
    flash[:error] =
      "We're sorry but we can't automatically upgrade your plan at this time. Please email info@agileventures.org to receive an upgrade"
    redirect_to user_path(current_user)
  end

  private

  def require_login?
    # we have this exception for paypal creation in test since we can't easily
    # maintain the capybara session for API endpoint hit
    true unless action_name == 'create' && paypal? && Rails.env.test?
  end

  def storable_location?
    (action_name == 'new') && current_user.nil?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  def detect_plan_before_payment
    Plan.find_by(third_party_identifier: params[:plan]) || default_plan
  rescue ActiveRecord::NotFound
    default_plan
  end

  def default_plan
    Plan.find_by(third_party_identifier: 'premium')
  end

  def detect_plan_after_payment
    id = params[:plan]
    Plan.find_by(third_party_identifier: id)
  end

  def detect_user
    return User.find_by slug: params[:user] if params[:user]

    current_user
  end

  def paypal?
    params[:payment_method] === 'paypal'
  end

  def create_stripe_customer
    @stripe_customer = Stripe::Customer.create(
      email: params[:stripeEmail],
      source: stripe_token(params),
      plan: @plan.third_party_identifier
    )
  end

  def is_sponsorship?
    @sponsee.present? && current_user != @sponsee
  end

  def stripe_token(params)
    Rails.env.test? ? generate_test_token : params[:stripeToken]
  end

  def generate_test_token
    StripeMock.create_test_helper.generate_card_token
  end

  def add_appropriate_subscription(user, sponsor = user)
    user ||= current_user
    return unless user

    payment_source = if paypal?
                       PaymentSource::PayPal.new identifier: params[:payer_id]
                     else
                       PaymentSource::Stripe.new identifier: @stripe_customer.id
                     end

    AddSubscriptionToUserForPlan.with(user, sponsor, Time.now, @plan, payment_source)
  end

  def send_acknowledgement_email
    payer_email = paypal? ? params[:email] : params[:stripeEmail]
    if is_sponsorship?
      Mailer.send_sponsor_premium_payment_complete(@sponsee.email, payer_email).deliver_now
    else
      Mailer.send_premium_payment_complete(@plan, payer_email).deliver_now
    end
  end

  def change_plan_through_stripe(user, new_subscription_plan)
    customer = Stripe::Customer.retrieve(user.stripe_customer_id)
    subscription = customer.subscriptions.retrieve(customer.subscriptions.first.id)
    subscription.plan = new_subscription_plan.third_party_identifier
    subscription.save
    payment_source = user.current_subscription.payment_source
    AddSubscriptionToUserForPlan.with(user, user, Time.now, new_subscription_plan, payment_source)
  end
end
