Given(/^the following articles exist:$/) do |table|
  temp_author = nil
  table.hashes.each do |raw_hash|
    hash = {}
    raw_hash.each_pair { |k, v| hash[k.to_s.downcase.squish.gsub(/\s+/, '_')] = v }
    if hash['author'].present?
      u = User.find_by_first_name hash['author']
      hash.except! 'author'
      u.articles.create(hash)
    else
      if temp_author.nil?
        temp_author = User.create first_name: 'First',
                                  last_name: 'Last',
                                  email: "dummy#{User.count}@users.co",
                                  password: '1234124124'
      end
      temp_author.articles.create hash
    end
  end
end
Then(/^I should see a preview containing:$/)  do   |table|
  content = table.raw.flatten
  new_window=page.driver.browser.window_handles.last
  page.within_window new_window do
    content.each do |text|
      page.should have_text text
    end
  end
end


When(/^I intend to see a preview of an article$/) do
  Capybara.current_driver = :selenium
end