class ChargesController < ApplicationController

  before_filter :authenticate_user!, only: [:edit, :update]

  def new
    render plan_name
  end

  def edit
  end

  def upgrade
    current_user.subscription.type = 'PremiumPlus'
    current_user.save
    customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
    subscription = customer.subscriptions.retrieve(customer.subscriptions.first.id)
    subscription.plan = "premiumplus"
    subscription.save
  end

  def create
    @plan = params[:plan]

    customer = Stripe::Customer.create(
        email: params[:stripeEmail],
        source: params[:stripeToken],
        plan: @plan
    )

    update_user_to_premium(customer)

    send_acknowledgement_email

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end

  def update
    customer = Stripe::Customer.retrieve(current_user.stripe_customer_id) # _token?
    card = customer.cards.create(card: params[:stripeToken])
    card.save
    customer.default_card = card.id
    customer.save
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while updating card info: #{e.message} for #{current_user}"
    @error = true
  end

  private

  def update_user_to_premium(stripe_customer)
    return unless current_user
    UpgradeUserToPremium.with(current_user, Time.now, stripe_customer.id, PaymentSource::Stripe, plan_class)
  end

  def plan_name
    return 'premium_mob' if params[:plan] == 'premiummob'
    return 'premium_f2f' if params[:plan] == 'premiumf2f'
    return 'premium_plus' if params[:plan] == 'premiumplus'
    'premium'
  end

  def plan_class
    plan_name.camelcase.constantize
  end

  def send_acknowledgement_email
    Mailer.send(acknowledgement_email_template, params[:stripeEmail]).deliver_now
  end

  def acknowledgement_email_template
    "send_#{plan_name}_payment_complete".to_sym
  end
end
