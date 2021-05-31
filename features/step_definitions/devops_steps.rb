# frozen_string_literal: true

When(/^I run the rake task for calculating karma points$/) do
  $rake['karma_calculator'].execute
end

When(/^I run the rake task for fetching github commits$/) do
  $rake['fetch_github_commits'].execute
end

When(/^I run the rake task for fetching github readme$/) do
  $rake['fetch_github:readme_files'].execute
end

When(/^I run the rake task for fetching github last_pushed_at information$/) do
  $rake['fetch_github_last_updates'].execute
end

When(/^I run the rake task for migrating stripe$/) do
  $rake['db:migrate_stripe'].execute
end

When(/^I run the rake task for fetching github languages/) do
  $rake['fetch_github_languages'].execute
end

When(/^I run the rake task for fetching static pages from github$/) do
  $rake['fetch_github:content_for_static_pages'].execute
end

Then(/^I should see all the pages on github in the site as static pages with the content from github$/) do
  visit static_page_path('About Us')
  expect(page).to have_content 'AgileVentures is an official UK Charity dedicated to crowdsourced learning and social coding'
  visit static_page_path('Code of Conduct')
  expect(page).to have_content 'A primary goal of Agile Ventures is to be inclusive to the largest number of contributors'
  visit static_page_path('Constitution')
  expect(page).to have_content 'is to provide a forum for any individual to develop their skills'
end

Then(/^"([^"]*)" shoud have "([^"]*)" in their subscription$/) do |email, stripe_id|
  user = User.find_by_email(email)
  expect(user.stripe_customer_id).to eq stripe_id
end

Given(/^the following payment sources exist$/) do |table|
  table.hashes.each do |hash|
    user = User.find_by(first_name: hash.delete('user'))
    subscription = Subscription.find_by(user_id: user.id)
    hash[:subscription_id] = subscription.id
    create(:paypal, hash)
  end
end

Given('the following subscriptions exist') do |table|
  table.hashes.each do |hash|
    user = User.find_by(first_name: hash.delete('user'))
    plan = Plan.find_by(name: hash[:type])
    hash[:user_id] = user.id
    hash[:started_at] = Time.now
    hash[:plan_id] = plan.id
    create(:subscription, hash)
  end
end

When(/^I run the rake task for migrating plans$/) do
  $rake['db:migrate_plans'].execute
end

When(/^I run the rake task for creating plans$/) do
  $rake['db:create_plans'].execute
end

Then(/^"([^"]*)" should have a "([^"]*)" subscription plan$/) do |email, plan|
  user = User.find_by_email(email)
  expect(user.current_subscription.plan).to eq Plan.find_by(name: plan)
end

Then(/^there should be a "([^"]*)" subscription plan$/) do |plan|
  expect(Plan.find_by(name: plan)).not_to be_nil
end

When(/^I hit the letsencrypt endpoint$/) do
  ENV['CERTBOT_SSL_CHALLENGE'] = 'qwertyui'
  @response = get '/.well-known/acme-challenge/123456789'
end

Then(/^I should receive the correct challenge response$/) do
  expect(@response.body).to eq '123456789.qwertyui'
end

When(/^I run the rake task for migrating github urls$/) do
  $rake['db:migrate_from_github_url_to_source_repository'].execute
end
