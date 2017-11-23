class AddSubscriptionToUserForPlan

  def self.with(user, sponsor, time, plan, payment_source, subscription_klass = Subscription)
    user.subscription = subscription_klass.new(started_at: time, sponsor: sponsor, plan: plan, payment_source: payment_source)
    user.title_list << plan.name
    user.save
  end

end
