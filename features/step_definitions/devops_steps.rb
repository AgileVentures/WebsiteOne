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
  expect(PaymentSource::Stripe.find_by_identifier(stripe_id)).not_to be_nil
  user = User.find_by_email(email)
  expect(user.subscription.payment_source.identifier).to eq stripe_id
end
