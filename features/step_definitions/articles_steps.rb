# frozen_string_literal: true

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
  find_button('Preview').trigger('click')
  sleep(0.1)
end

Then(/^I should see a preview containing:$/) do |table|
  content = table.raw.flatten
  preview_window = windows.last
  page.within_window preview_window do
    content.each do |text|
      expect(page).to have_text text
    end
  end
end
