# frozen_string_literal: true

Given(/^the following documents exist:$/) do |table|
  table.hashes.each do |hash|
    if hash[:project].present?
      hash[:project_id] = Project.find_by_title(hash[:project]).id
      hash.except! 'project'
    end
    if hash[:author].present?
      u = User.find_by_first_name hash[:author]
      hash.except! 'author'
      document = u.documents.new hash
    else
      document = default_test_author.documents.new hash
    end

    document.save!
  end
end

Given(/^the following revisions exist$/) do |table|
  table.hashes.each do |hash|
    hash[:revisions].to_i.times do |number|
      doc = Document.find_by_title(hash[:title])
      doc.update(body: "New content #{number}")
      doc.save!
    end
  end
end

When(/^I should not see the document "([^"]*)"$/) do |title|
  expect(page).not_to have_selector('title', text: title)
end

When(/^I click the sidebar link "([^"]*)"$/) do |link|
  within('#sidebar') do
    click_link_or_button link
  end
end

When(/^I click "([^"]*)" in "([^"]*)"$/) do |link, scope|
  within(selector_for(scope)) { step %(I click "#{link}") }
end

When(/^I should see ([^"]*) revisions for "([^"]*)"$/) do |revisions, document|
  doc = Document.find_by_title(document)
  expect doc.versions.count == revisions
  expect(page).to have_xpath('//div[@id="revisions"]/b', count: revisions)
end

When(/^I should not see any revisions$/) do
  expect(page).not_to have_css('#revisions')
end
