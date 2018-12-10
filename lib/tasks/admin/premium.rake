
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
  task :paypal, [:email, :datetime, :identifier] => [:environment] do |task, args|
    user = User.find_by email: args[:email]
    payment_source = PaymentSource::PayPal.new identifier: args[:identifier]  # 'I-NCTHXP8EERRR'
    plan = Plan.find(1)
    datetime = args[:datetime] || DateTime.now # '2016-10-31 10:58:08'
    time = DateTime.parse(datetime)
    AddSubscriptionToUserForPlan.with(user, user, time, plan, payment_source)
  end 
  task :end_subscription, [:email, :datetime] => [:environment] do
    user = User.find_by email: args[:email]
    subscription = user.current_subscription
    subscription.ended_on = DateTime.parse(args[:datetime]) #  '2018-07-10 11:38:13'
    subscription.save
  end
  desc 'remove premium title that has got out of sync with membership status'
  task :remove_premium_title, [:email] => [:environment] do
    user = User.find_by email: args[:email]
    user.title_list.delete 'Premium'
    user.save
  end
end