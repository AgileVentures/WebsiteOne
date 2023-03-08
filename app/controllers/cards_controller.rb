# frozen_string_literal: true

class CardsController < ApplicationController
  before_action :authenticate_user!

  def new; end

  def edit; end

  def create
    customer = Stripe::Customer.create(email: params[:stripeEmail])
    card = customer.sources.create(card: stripe_token(params))
    card.save
    customer.default_card = card.id
    customer.save
  rescue Stripe::StripeError, StandardError => e
    logger.error "Stripe error while adding card info: #{e.message} for #{current_user}"
    @error = true
  end

  def update
    customer = Stripe::Customer.retrieve(current_user.stripe_customer_id) # _token?
    card = customer.sources.create(card: stripe_token(params))
    card.save
    customer.default_card = card.id
    customer.save
  rescue Stripe::StripeError, StandardError => e
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
