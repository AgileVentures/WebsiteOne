Before('@selenium') do
  Capybara.current_driver = :selenium
end

After('@selenium') do
  Capybara.current_driver = Capybara.default_driver
end

Before('@time-travel') do
  @default_tz = ENV['TZ']
  ENV['TZ'] = 'UTC'
  Delorean.time_travel_to(Time.parse('2014/02/01 09:15:00 UTC'))
end

After('@time-travel') do
  Delorean.back_to_the_present
  ENV['TZ'] = @default_tz
end