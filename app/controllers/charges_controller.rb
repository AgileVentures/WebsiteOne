class ChargesController < ApplicationController

  def new
  end

  def create
    # Amount in cents
    @amount = 1000

    customer = Stripe::Customer.create(
        email:  params[:stripeEmail],
        source: params[:stripeToken],
        plan:  'premium'
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

end
