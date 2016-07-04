class ChargesController < ApplicationController

  def new
    render 'premiumplus' and return if premiumplus?
    render 'premium'
  end

  def create
    @plan = params[:plan]

    customer = Stripe::Customer.create(
        email:  params[:stripeEmail],
        source: params[:stripeToken],
        plan:   @plan
    )

    send_acknowledgement_email

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
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
