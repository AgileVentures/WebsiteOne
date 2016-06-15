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

    # charge = Stripe::Charge.create(
    #     :customer    => customer.id,
    #     :amount      => @amount,
    #     :description => 'Rails Stripe customer',
    #     :currency    => 'gbp'
    # )

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end

  private

  def premiumplus?
    params[:plan] == 'premiumplus'
  end

end
