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
  # 1. A comment "#{comment}" has been manually entered for an article
  # with id='#{test_id}'
  
  test_id = 51
  document = Document.find_by_title(title)
  document.update(id: test_id) if document  # set to the id of existing comment
end

Given /^article "([^"]+)" has comment "([^"]+)"$/ do |title, comment|
  # THIS STEP ASSUMES THE FOLLOWING:
  # 1. A comment "#{comment}" has been manually entered for an article
  # with id='#{test_id}'
  
  test_id = 36
  article = Article.find_by_title(title)
  article.update(id: test_id) if article # set to the id of existing comment
end

Then /^(.*) in Disqus section$/ do |step|
    page.driver.within_frame('dsq-2') { step(step) }
end

When /^I wait (\d+) seconds for.+$/ do |time|
  sleep(time.to_i)
end
