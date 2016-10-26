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
