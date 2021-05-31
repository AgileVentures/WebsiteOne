# frozen_string_literal: true

require 'paypal-sdk-rest'

PayPal::SDK::REST.set_config(
  mode: ENV['PAYPAL_SDK_MODE'],
  client_id: ENV['PAYPAL_CLIENT_ID'],
  client_secret: ENV['PAYPAL_CLIENT_SECRET']
)

class PaypalService
  def initialize(plan)
    @plan = plan
  end

  def create_and_activate_recurring_plan
    plan_type = @plan.third_party_identifier === 'premium' ? plan_params_with_trial : plan_params_without_trial
    plan = PayPal::SDK::REST::Plan.new(plan_type)
    plan.update(activate_plan_params) if plan.create
    plan
  end

  def create_agreement
    id = @plan.paypal_id
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
      payment_definitions: [regular_payment_definition, trial_payment_definition],
      merchant_preferences: merchant_preferences
    }
  end

  def plan_params_without_trial
    {
      name: @plan.name,
      description: "#{@plan.name} membership for £#{@plan.amount / 100}/month",
      type: 'FIXED',
      payment_definitions: [regular_payment_definition],
      merchant_preferences: merchant_preferences
    }
  end

  def agreement_params(plan)
    {
      name: plan.name,
      description: "#{plan.name} membership for £#{plan.payment_definitions[0].amount.value}/month",
      start_date: (DateTime.now + 2.days).iso8601,
      payer: { payment_method: 'paypal' },
      plan: { id: plan.id }
    }
  end

  def merchant_preferences
    {
      setup_fee:
        {
          currency: 'GBP',
          value: '0'
        },
      return_url: "#{ENV['BASE_URL']}/paypal/create?plan=#{@plan.third_party_identifier}",
      cancel_url: "#{ENV['BASE_URL']}/subscriptions/new?plan=#{@plan.third_party_identifier}",
      auto_bill_amount: 'YES',
      initial_fail_amount_action: 'CONTINUE',
      max_fail_attempts: '0'
    }
  end

  def regular_payment_definition
    {
      name: 'Regular payment definition',
      type: 'REGULAR',
      frequency_interval: '1',
      frequency: 'MONTH',
      cycles: '12',
      amount:
      {
        currency: 'GBP',
        value: @plan.amount / 100
      }
    }
  end

  def trial_payment_definition
    {
      name: 'Trial payment definition',
      type: 'trial',
      frequency_interval: '1',
      frequency: 'week',
      cycles: '1',
      amount:
      {
        currency: 'GBP',
        value: '0'
      }
    }
  end
end
