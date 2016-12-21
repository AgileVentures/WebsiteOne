When(/^I run the rake task for calculating karma points$/) do
  $rake['karma_calculator'].execute
end

When(/^I run the rake task for fetching github commits$/) do
  $rake['fetch_github_commits'].execute
end

When(/^I run the rake task for migrating stripe$/) do
  $rake['db:migrate_stripe'].execute
end

Then(/^"([^"]*)" shoud have "([^"]*)" in their subscription$/) do |email, stripe_id|
  user = User.find_by_email(email)
  expect(user.stripe_customer_id).to eq stripe_id
end

Given(/^the following payment sources exist$/) do |table|
  table.hashes.each do |hash|
    user = User.find_by(first_name: hash.delete('user'))
    subscription = Subscription.find_by(user_id: user.id)
    hash[:subscription_id] = subscription
    PaymentSource::PaymentSource.create!(hash)
  end
end

Given(/^the following subscriptions exist$/) do |table|
  table.hashes.each do |hash|
    user = User.find_by(first_name: hash.delete('user'))
    hash[:user_id] = user.id
    hash[:started_at] = Time.now
    Subscription.create!(hash)
  end
end

When(/^I run the rake task for migrating plans$/) do
  $rake['db:migrate_plans'].execute
end

Then(/^"([^"]*)" should have a "([^"]*)" subscription plan$/) do |email, plan|
  user = User.find_by_email(email)
  expect(user.subscription.plan).to eq Plan.find_by(name: plan)
end

