class AddSubscriptionToUserForPlan

  def self.with(user, sponsor, time, plan, payment_source, subscription_klass = Subscription)
    # TODO must ensure all previous subscriptions are ended
    user.subscriptions << subscription_klass.new(started_at: time, sponsor: sponsor, plan: plan, payment_source: payment_source)
    user.title_list << plan.name
    user.save
  end

end
