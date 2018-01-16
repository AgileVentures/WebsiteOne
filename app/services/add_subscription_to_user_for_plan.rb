class AddSubscriptionToUserForPlan

  def self.with(user, sponsor, time, plan, payment_source, subscription_klass = Subscription)
    ensure_all_previous_subscriptions_are_ended(user, time)
    user.subscriptions << subscription_klass.new(started_at: time, sponsor: sponsor, plan: plan, payment_source: payment_source)
    user.title_list << plan.name
    user.save!
    # puts User.find(user.id).subscriptions.map{|s| s.inspect}
  end

  def self.ensure_all_previous_subscriptions_are_ended(user, time)
    unended_subs = user.subscriptions.select { |s| s.ended_at.nil? }
    unended_subs.each { |s| s.ended_at = time }
  end

end
