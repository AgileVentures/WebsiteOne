Given /^Disqus is setup$/ do
  # THIS INTEGRATION TEST ASSUMES THE FOLLOWING:
  # 1. An account has been setup with Disqus
  # 2. DISQUS_SHORTNAME has been set to the Disqus account name in config/initializers/disqus.rb
  # 3. Disqus is online and functioning correctly
  # 4. Admin panel can be accessed at #{account_name}.disqus.com
  #
  # Ideally, we should avoid requests to 3-rd party services, so we would need
  # to record the response of Disqus, stub the request and replay
  # the response to the headless browser.  That can be done with Puffing Billy gem.
end

Given /^document "([^"]+)" has comment "([^"]+)"$/ do |title, comment|
  # THIS STEP ASSUMES THE FOLLOWING:
  # 1. A comment "#{comment}" has been manually entered for an document
  # with title =  '#{title}'
end

Given /^article "([^"]+)" has comment "([^"]+)"$/ do |title, comment|
  # THIS STEP ASSUMES THE FOLLOWING:
  # 1. A comment "#{comment}" has been manually entered for an article
  # with title =  '#{title}'
end

Then /^(.*) in Disqus section$/ do |step|
  page.driver.within_frame('dsq-2') { step(step) }
end

When /^I wait up to (\d+) seconds for Disqus comments to load$/ do |time|
  Timeout::timeout(time.to_i) {
    until page.has_css?('iframe#dsq-2') do
      sleep(0.005)
    end
  }
end
