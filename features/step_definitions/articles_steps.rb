Given(/^the following articles exist:$/) do |table|
  table.hashes.each do |raw_hash|
    hash = {}
    raw_hash.each_pair { |k, v| hash[k.to_s.downcase.squish.gsub(/\s+/, '_')] = v }
    if hash['author'].present?
      u = User.find_by_first_name hash['author']
      hash.except! 'author'
      article = u.articles.new hash
    else
      article = default_test_author.articles.new hash
    end

    article.save!
  end
end

When(/^I click the Preview button$/) do
  find_button("Preview").trigger("click")
  sleep(0.1)
end

Then(/^I should see a preview containing:$/) do |table|
  content = table.raw.flatten
  page.within_window(page.driver.window_handles.last) do
    content.each do |text|
      page.should have_text text
    end
  end
end
