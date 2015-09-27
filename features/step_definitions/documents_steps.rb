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
      doc.update(:body => "New content #{number}")
      doc.save!
    end
  end
end

When(/^I click the "([^"]*)" button for document "([^"]*)"$/) do |button, document_name|
  document = Document.find_by_title(document_name)
  if document
    within("tr##{document.id}") do
      click_link_or_button button
    end
  else
    visit path_to(button, 'non-existent')
  end
end

When(/^I should not see the document "([^"]*)"$/) do |title|
  page.should have_text title, visible: false
end

When(/^I click the sidebar link "([^"]*)"$/) do |link|
  within('#sidebar') do
    click_link_or_button link
  end
end

When(/^I click "([^"]*)" in "([^"]*)"$/) do |link, scope|
  within(selector_for(scope)) { step %Q{I click "#{link}"} }
end

When(/^I should see ([^"]*) revisions for "([^"]*)"$/) do |revisions, document|
  doc = Document.find_by_title(document)
  expect doc.versions.count == revisions
  expect(page).to have_xpath('//div[@id="revisions"]/b', count: revisions)
end

When(/^I should not see any revisions$/) do
  expect(page).not_to have_css('#revisions')
end
