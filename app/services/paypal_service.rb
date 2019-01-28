require 'paypal-sdk-rest'
include PayPal::SDK::REST

PayPal::SDK::REST.set_config(
  mode: 'sandbox', # "sandbox" or "live"
  client_id: ENV['PAYPAL_CLIENT_ID'],
  client_secret: ENV['PAYPAL_CLIENT_SECRET']
)

class PaypalService
  def initialize(plan)
    @plan = plan
  end
  
  def create_and_activate_recurring_plan
    plan = PayPal::SDK::REST::Plan.new(plan_params_without_trial)
    plan = PayPal::SDK::REST::Plan.new(plan_params_with_trial) if @plan.third_party_identifier === 'premium'
    plan.update(activate_plan_params) if plan.create
    plan
  end
  
  def create_agreement(plan)
    agreement = PayPal::SDK::REST::Agreement.new(agreement_params(plan.id))
    agreement.create
    agreement
  end
  
  def create_recurring_agreement
    plan = create_and_activate_recurring_plan
    agreement = create_agreement(plan) if plan.success?
    (plan unless plan.success?) || agreement
  end
  
  def self.execute_agreement(agreement_token)
    agreement = PayPal::SDK::REST::Agreement.new(token: agreement_token)
    agreement.execute unless agreement.error
    agreement
  end

  private
  
  def activate_plan_params
    {
      op: 'replace',
      value: { state: 'ACTIVE' },
      path: '/'
    }
  end

  def plan_params_with_trial
    {
      name: @plan.name,
      description: "#{@plan.name} membership for £#{@plan.amount / 100}/month",
      type: 'FIXED',
      payment_definitions: [
        {
          name: "Regular payment definition",
          type: "REGULAR",
          frequency_interval: "1",
          frequency: "MONTH",
          cycles: "12",
          amount:
          {
            currency: "GBP",
            value: @plan.amount
          }
        },
        {
          name: "Trial payment definition",
          type: "trial",
          frequency_interval: "1",
          frequency: "week",
          cycles: "1",
          amount:
          {
            currency: "GBP",
            value: "0"
          }
        }],
      merchant_preferences: {
        setup_fee:
        {
          currency: "GBP",
          value: "0"
        },
        return_url: "http://localhost:3000/subscriptions/execute?plan=#{@plan.third_party_identifier}",
        cancel_url: "http://localhost:3000/subscriptions/new?plan=#{@plan.third_party_identifier}",
        auto_bill_amount: "YES",
        initial_fail_amount_action: "CONTINUE",
        max_fail_attempts: "0"
      },
    }
  end

  def plan_params_without_trial
    {
      name: @plan.name,
      description:  "#{@plan.name} membership for £#{@plan.amount / 100}/month",
      type: 'FIXED',
      payment_definitions: [
        {
          name: "Regular payment definition",
          type: "REGULAR",
          frequency_interval: "1",
          frequency: "MONTH",
          cycles: "12",
          amount:
          {
            currency: "GBP",
            value: @plan.amount
          }
        }],
      merchant_preferences: {
        setup_fee:
        {
          currency: "GBP",
          value: "0"
        },
        return_url: "http://localhost:3000/subscriptions/execute?plan=#{@plan.third_party_identifier}",
        cancel_url: "http://localhost:3000/subscriptions/new?plan=#{@plan.third_party_identifier}",
        auto_bill_amount: "YES",
        initial_fail_amount_action: "CONTINUE",
        max_fail_attempts: "0"
      },
    }
  end
  
  def agreement_params(plan_id)
    {
      name: @plan.name,
      description: "#{@plan.name} membership for £#{@plan.amount / 100}/month",
      start_date: (DateTime.now + 2.days).iso8601,
      payer: { payment_method: 'paypal' },
      plan: { id: plan_id }
    }
  end
end