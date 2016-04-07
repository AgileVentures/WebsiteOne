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
  month_in_seconds = 1.month.seconds.to_i
  FactoryGirl.create_list(:event_instance, 25, category: 'Scrum', created_at: rand(month_in_seconds).seconds.ago, project_id: nil)
    #VCR.insert_cassette(
  #  'scrums_controller/videos_by_query'
  #)
end


After('@scrum_query') {EventInstance.destroy_all }

Before('@github_query') do
  VCR.insert_cassette(
    'github_commit_count/websiteone_stats'
  )
end
After('@github_query') { VCR.eject_cassette }

Around('@poltergeist') do |_scenario, block|
  execute_with_driver(block, :poltergeist)
end

Before('@desktop') {page.driver.resize(1228, 768)}

Before('@tablet') {page.driver.resize(768, 768)}

Before('@smartphone') {page.driver.resize(640, 640)}

After('@desktop', '@tablet', '@smartphone') {page.driver.resize(1600, 1200)}

Around('@mercury_step') do |_scenario, block|
  execute_with_driver(block, :poltergeist_billy_debug)
end

def execute_with_driver(block, driver)
  original_driver = Capybara.javascript_driver
  Capybara.javascript_driver = driver
  block.call
  Capybara.javascript_driver = original_driver
end

