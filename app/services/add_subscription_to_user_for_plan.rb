class AddSubscriptionToUserForPlan

  def self.with(user, time, third_party_id, plan, payment_source_klass = PaymentSource::Stripe, subscription_klass = Subscription)
    payment_source = payment_source_klass.new(identifier: third_party_id)
    user.subscription = subscription_klass.new(started_at: time, plan: plan, payment_source: payment_source)
    user.title_list << plan.name
    user.save
  end

end