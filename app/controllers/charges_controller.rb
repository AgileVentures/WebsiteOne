class ChargesController < ApplicationController

  before_filter :authenticate_user!, only: [:edit, :update]

  def new
    render 'premiumplus' and return if premiumplus?
    render 'premium'
  end

  def edit
  end

  def create
    @plan = params[:plan]

    customer = Stripe::Customer.create(
        email: params[:stripeEmail],
        source: params[:stripeToken],
        plan: @plan
    )

    send_acknowledgement_email

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end

  def update
    customer = Stripe::Customer.retrieve(current_user.stripe_customer) # _token?
    card = customer.cards.create(card: params[:stripeToken])
    card.save
    customer.default_card = card.id
    customer.save
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while updating card info: #{e.message}"
    @error = true
    false
  end

  private

  def premiumplus?
    params[:plan] == 'premiumplus'
  end

  def send_acknowledgement_email
    Mailer.send(acknowledgement_email_template, params[:stripeEmail]).deliver_now
  end

  def acknowledgement_email_template
    "send_premium#{premiumplus? ? '_plus' : ''}_payment_complete".to_sym
  end
end
