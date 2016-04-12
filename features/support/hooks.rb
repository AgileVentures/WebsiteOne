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