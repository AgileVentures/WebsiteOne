Given(/^the following documents exist:$/) do |table|
  table.hashes.each do |hash|
    project = Document.create(hash)
    project.save
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
