# frozen_string_literal: true

# Before('@poltergeist_no_billy') do
#   Capybara.javascript_driver = :ignore_ssl_errors
#   Capybara.current_driver = Capybara.javascript_driver
#   # @original_javascript_driver = Capybara.javascript_driver
# end

# After('@poltergeist_no_billy') do
#   Capybara.javascript_driver =  @original_javascript_driver
#

Before '@disable_twitter' do
  @original_twitter = Settings.features.twitter.notifications.enabled
  Settings.features.twitter.notifications.enabled = false
end

After '@disable_twitter' do
  Settings.features.twitter.notifications.enabled = @original_twitter
end

After '@javascript' do
  Capybara.send('session_pool').each do |_, session|
    next unless session.driver.is_a?(Capybara::Poltergeist::Driver)

    session.driver.restart
  end
end

# have added the below because while the youtube video player works
# it generates some errors that stop the tests from running ...
#
# see https://github.com/AgileVentures/WebsiteOne/issues/1754

Before '@javascript_ignore_js_errors' do
  Capybara.javascript_driver = :poltergeist
  Capybara.current_driver = Capybara.javascript_driver
end

After '@javascript_ignore_js_errors' do
  Capybara.javascript_driver = :poltergeist_billy
  Capybara.current_driver = Capybara.javascript_driver
end

Before '@stripe_javascript' do
  Capybara.javascript_driver = :poltergeist
  Capybara.current_driver = Capybara.javascript_driver
  StripeMock.start
  @stripe_test_helper = StripeMock.create_test_helper
end

After '@stripe_javascript' do
  Capybara.javascript_driver = :poltergeist_billy
  StripeMock.stop
  Capybara.send('session_pool').each do |_, session|
    next unless session.driver.is_a?(Capybara::Poltergeist::Driver)

    session.driver.restart
  end
end

Before('@desktop') do
  page.driver.resize(1228, 768)
end

Before('@tablet') { page.driver.resize(768, 768) }

Before('@smartphone') { page.driver.resize(640, 640) }

After('@desktop', '@tablet', '@smartphone') { page.driver.resize(1600, 1200) }

Before('@time-travel') do
  @default_tz = ENV['TZ']
  ENV['TZ'] = 'UTC'
  Delorean.time_travel_to(Time.parse('2014/02/01 09:15:00 UTC'))
end

Before('@time-travel-step') do
  @default_tz = ENV['TZ']
  ENV['TZ'] = 'UTC'
end

After('@time-travel or @time-travel-step') do
  Delorean.back_to_the_present
  ENV['TZ'] = @default_tz
end

Before('@omniauth') do
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:github] = {
    'provider' => 'github',
    'uid' => '12345678',
    'info' => {
      'email' => 'mock@email.com'
    }
  }
  OmniAuth.config.mock_auth[:gplus] = {
    'provider' => 'gplus',
    'uid' => '12345678',
    'info' => {
      'email' => 'mock@email.com'
    },
    'credentials' => { 'token' => 'test_token' }
  }
end

Before('@omniauth-with-invalid-credentials') do
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:gplus] = :invalid_credentials
  OmniAuth.config.mock_auth[:github] = :invalid_credentials
end

Before('@omniauth-without-email') do
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:github] = {
    'provider' => 'github',
    'uid' => '12345678',
    'info' => {}
  }
  OmniAuth.config.mock_auth[:gplus] = {
    'provider' => 'gplus',
    'uid' => '12345678',
    'info' => {},
    'credentials' => { 'token' => 'test_token' }
  }
end

After('@omniauth or @omniauth-with-email or @omniauth-with-invalid-credentials') do
  OmniAuth.config.test_mode = false
end

Before('@rake') do |_scenario|
  unless $rake
    require 'rake'
    Rake.application.rake_require 'tasks/github_content_for_static_pages'
    Rake.application.rake_require 'tasks/scheduler'
    Rake.application.rake_require 'tasks/migrate_plans'
    Rake.application.rake_require 'tasks/create_plans'
    Rake.application.rake_require 'tasks/db'
    Rake::Task.define_task(:environment)
    $rake = Rake::Task
  end
end
