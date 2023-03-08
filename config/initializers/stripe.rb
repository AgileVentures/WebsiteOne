# frozen_string_literal: true

Rails.configuration.stripe = {
  publishable_key: ENV.fetch('STRIPE_PUBLISHABLE_KEY', nil),
  secret_key: ENV.fetch('STRIPE_SECRET_KEY', nil)
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
