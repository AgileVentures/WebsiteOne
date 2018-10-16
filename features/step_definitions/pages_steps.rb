def static_page_path(page)
  "/#{StaticPage.url_for_me(page)}"
end

Given(/^the following pages exist$/) do |table|
  table.hashes.each do |hash|
    StaticPage.create!(hash)
  end
end 

Then /^I (am|should be) on the static "([^"]*)" page$/ do |option, page|
  case option
    when 'am'
      visit static_page_path(page)
    when 'should be'
      expect(current_path).to eq static_page_path(page)
    else
      pending
  end
end
When(/^I (try to use|am using) the Mercury Editor to edit static "([^"]*)" page$/) do |opt, title|
  visit "/editor#{static_page_path(title)}"
end

Given(/^the following page revisions exist$/) do |table|
  table.hashes.each do |hash|
    hash[:revisions].to_i.times do |number|
      page = StaticPage.find_by_title(hash[:title])
      page.update(:body => "New content #{number}")
      page.save!
    end
  end
end

When(/^I should see ([^"]*) revisions for the page "([^"]*)"$/) do |revisions, document|
  page = StaticPage.find_by_title(document)
  expect page.versions.count == revisions
end

Given(/^the page "([^"]*)" has a child page with title "([^"]*)"$/) do |parent, child|
  parent_page = StaticPage.find_by_title(parent)
  StaticPage.create!(
      {
          title: child,
          parent_id: parent_page.id
      }
  )
end

Then(/^the current page url should be "([^"]*)"$/) do |url|
  expect(current_path).to eq "/#{url}"
end

Then(/^I should see ancestry "([^"]*)"$/) do |str|
  ancestry = str.split(" >> ")
  within("#ancestry") do
    ancestry.each do |a|
      expect(page).to have_content a
    end
  end
end

Then(/^the "([^"]*)" page title should read "([^"]*)"$/) do |str, title|
	visit path_to(str)
	expect(page.title).to eq "#{title}"
end

Then(/^I see the banners for all sponsors$/) do
  sponsors = {
    "Standuply" => "https://standuply.com/?utm_source=links&utm_medium=agileventures&utm_campaign=partnership",
    "Craft Academy" => "http://craftacademy.se/english",
    "Mooqita" => "https://mooqita.org/",
    "Amazon Smile" => "https://smile.amazon.co.uk/ch/1170963-0"
  }
  sponsors.each do |alt_text, url|
    within("//a[@href='#{url}']/div") do
      expect(page).to have_selector("img[@alt='#{alt_text}']")
    end
  end
end
