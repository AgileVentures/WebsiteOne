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

Before('@desktop') { page.driver.resize(1228, 768) }

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

After('@time-travel , @time-travel-step') do
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
      'credentials' => {'token' => 'test_token'}
  }
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
      'credentials' => {'token' => 'test_token'}
  }
end

After('@omniauth, @omniauth-with-email') do
  OmniAuth.config.test_mode = false
end

Before('@rake') do |scenario|
  unless $rake
    require 'rake'
    Rake.application.rake_require 'tasks/scheduler'
    Rake.application.rake_require 'tasks/migrate_stripe_customer_ids'
    Rake::Task.define_task(:environment)
    $rake = Rake::Task
  end
end