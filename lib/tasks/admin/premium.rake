
namespace :util do
  task :mentor_incentive => :environment [:email, :datetime] do |task, args|
    user = User.find_by email: args[:email]
    payment_source = PaymentSource::Other.new identifier: 'mentor incentive'
    plan = Plan.find(2)
    datetime = args[:datetime] || DateTime.now # '2018-08-04 10:58:08'
    time = DateTime.parse(datetime)
    AddSubscriptionToUserForPlan.with(user, user, time, plan, payment_source)
  end 
  task :paypal => :environment [:email, :datetime, :identifier] do |task, args|
    user = User.find_by email: args[:email]
    payment_source = PaymentSource::PayPal.new identifier: args[:identifier] 'I-NCTHXP8EERRR'
    plan = Plan.find(1)
    datetime = args[:datetime] || DateTime.now # '2016-10-31 10:58:08'
    time = DateTime.parse(datetime)
    AddSubscriptionToUserForPlan.with(user, user, time, plan, payment_source)
  end 
end