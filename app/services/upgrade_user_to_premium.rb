class UpgradeUserToPremium

  def self.with(user, time, stripe_id, payment_source_klass = PaymentSource::Stripe, subscription_klass = Premium)
    payment_source = payment_source_klass.new(identifier: stripe_id)
    user.subscription = subscription_klass.new(started_at: time, payment_source: payment_source)
    user.title_list << 'Premium'
    user.save
  end

end