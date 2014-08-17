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

Before('@visitor-does-SSO') do
  OmniAuth.config.test_mode = true
  %w.github gplus..each do |auth|
    OmniAuth.config.mock_auth[auth.to_sym] = {
      'provider' => auth,
      'uid' => '12345678',
      'credentials' => { "expires" => false, "token" => "FAKETOKEN" },
      'info' => { 'email' => 'mock@example.com' },
    }
    AuthenticationProvider.create(name: auth)
  end
end

Before('@visitor-does-SSO-no-email') do
  OmniAuth.config.test_mode = true
  %w.github gplus..each do |auth|
    OmniAuth.config.mock_auth[auth.to_sym] = {
      'provider' => auth,
      'uid' => '12345678',
      'credentials' => { "expires" => false, "token" => "FAKETOKEN" },
      'info' => {},
    }
    AuthenticationProvider.create(name: auth)
  end
end

Before('@user-does-SSO') do
  OmniAuth.config.test_mode = true
  %w.github gplus..each do |auth|
    OmniAuth.config.mock_auth[auth.to_sym] = {
      'provider' => auth,
      'uid' => '12345678',
      'credentials' => { "expires" => false, "token" => "FAKETOKEN" },
      'info' => {
        'email' => ->{ create_user; @user.email }.()
      },
    }
    AuthenticationProvider.create(name: auth)
  end
end

After('@visitor-does-SSO, @visitor-does-SSO-no-email, @user-does-SSO') do
  OmniAuth.config.test_mode = false
end

Before('@scrum_query') do
  VCR.insert_cassette(
    'scrums_controller/videos_by_query'
  )
end
After('@scrum_query') { VCR.eject_cassette }
