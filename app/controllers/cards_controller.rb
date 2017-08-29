class CardsController < ApplicationController

  before_action :authenticate_user!

  def edit
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

  def stripe_token(params)
    Rails.env.test? ? generate_test_token : params[:stripeToken]
  end

  def generate_test_token
    StripeMock.create_test_helper.generate_card_token
  end

end