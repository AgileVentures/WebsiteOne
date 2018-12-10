
namespace :util do
  desc 'give premium mob membership as part of the mentor incentive package'
  task :mentor_incentive, [:email, :datetime] => [:environment] do |task, args|
    user = User.find_by email: args[:email]
    payment_source = PaymentSource::Other.new identifier: 'mentor incentive'
    plan = Plan.find(2)
    datetime = args[:datetime] || DateTime.now # '2018-08-04 10:58:08'
    time = DateTime.parse(datetime)
    AddSubscriptionToUserForPlan.with(user, user, time, plan, payment_source)
  end 
  desc 'Add record of a Premium subscription using a paypal identifier'
  task :paypal, [:email, :datetime, :identifier] => [:environment] do |task, args|
    user = User.find_by email: args[:email]
    payment_source = PaymentSource::PayPal.new identifier: args[:identifier]  # 'I-V7VNUGP2TEG7'
    plan = Plan.find(1)
    datetime = args[:datetime] || DateTime.now # '2018-09-26 10:58:08'
    time = DateTime.parse(datetime)
    AddSubscriptionToUserForPlan.with(user, user, time, plan, payment_source)
  end 
  desc 'mark a subscription as ended'
  task :end_subscription, [:email, :datetime] => [:environment] do
    user = User.find_by email: args[:email]
    subscription = user.current_subscription
    subscription.ended_at = DateTime.parse(args[:datetime]) #  '2018-05-27 11:38:13'
    subscription.save
    user.title_list.delete subscription.plan.name # and need to remove lower level tags too ..?
    user.save
    # note that this does not remove anything from title lists ...
    # maybe we need RemoveSubscriptionFromUserForPlan or even
    # CancelCurrentSubscriptionForUser ?

    # would be nice if we could also control slack channel membership from here ...
  end
  desc 'remove premium title that has got out of sync with membership status'
  task :remove_premium_title, [:email] => [:environment] do
    user = User.find_by email: args[:email]
    user.title_list.delete 'Premium'
    user.save
  end
end