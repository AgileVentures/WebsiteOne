require 'paypal-sdk-rest'

PayPal::SDK::REST.set_config(
  mode: 'sandbox', # "sandbox" or "live"
  client_id: ENV['PAYPAL_CLIENT_ID'],
  client_secret: ENV['PAYPAL_CLIENT_SECRET']
)

class PaypalService
  def create_agreement(id)
    plan = PayPal::SDK::REST::Plan.find(id)
    agreement = PayPal::SDK::REST::Agreement.new(agreement_params(plan))
    agreement.create
    agreement
  end
  
  def self.execute_agreement(agreement_token)
    agreement = PayPal::SDK::REST::Agreement.new(token: agreement_token)
    agreement.execute unless agreement.error
    agreement
  end

  private
  
  def agreement_params(plan)
    {
      name: plan.name,
      description: "#{plan.name} membership",
      start_date: (DateTime.now + 2.days).iso8601,
      payer: { payment_method: 'paypal' },
      plan: { id: plan.id }
    }
  end
end