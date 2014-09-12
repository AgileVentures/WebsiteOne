Before('@enable-custom-errors') do
  Features.enable(:custom_errors)
end

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

Before('@scrum_query') do
  VCR.insert_cassette(
    'scrums_controller/videos_by_query'
  )
end
After('@scrum_query') { VCR.eject_cassette }

Before('@github_query') do
  VCR.insert_cassette(
    'github_commit_count/websiteone_stats'
  )
end
After('@github_query') { VCR.eject_cassette }


Before('@poltergeist') do
  Capybara.javascript_driver = :poltergeist
end

Before('@desktop') {page.driver.resize(1228, 768)}

Before('@tablet') {page.driver.resize(768, 768)}

Before('@smartphone') {page.driver.resize(640, 640)}

After('@desktop', '@tablet', '@smartphone') {page.driver.resize(1600, 1200)}

After('@poltergeist', '@desktop', '@tablet', '@smartphone') do
  Capybara.javascript_driver = :rack_test
end