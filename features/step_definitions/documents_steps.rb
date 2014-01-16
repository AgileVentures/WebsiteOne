Given(/^the following documents exist:$/) do |table|
  table.hashes.each do |hash|
    project = Document.create(hash)
    project.save
  end
end

# Bryan: This is not valid, no project id
#Then(/^I should be on documents page$/) do
#  expect(current_path).to eq project_documents_path
#end

Then(/^I should be on the documents page for project "([^"]*)"$/) do |title|
  id = Project.find_by_title(title).id
  expect(current_path).to eq project_documents_path(id)
end

Then(/I should be on "([^"]*)" documents page for document "([^"]*)"/) do |action, title|
  id = Document.find_by_title(title).id
  action = action.downcase.singularize
  p
  if action == 'show'
    expect(current_path).to eq document_path(id)
  else
    expect(current_path).to eq eval("#{action}_document_path(#{id})")
  end
end

# TODO Bryan: pretty hackish way, possibly could use refactoring
When(/I click the "([^"]*)" button for document "([^"]*)"/) do |button, title|
  all(:xpath, '//tbody/tr').each do |elem|
    begin
      elem.find(:xpath, 'td', text: title)
      elem.click_link_or_button button
    rescue
      # do nothing
    end
  end
end

When(/^I should see a link to "([^"]*)" page for document "([^"]*)"$/) do |action, title|
  id = Document.find_by_title(title).id
  action = action.downcase.singularize
  # TODO figure out why this always returns www.example.com
  #url_for(controller: :documents, action: action, id: id)
  if action == 'show'
    expected_path = document_path(id)
  else
    expected_path = eval("#{action}_document_path(#{id})")
  end
  page.has_link?(action, href: expected_path)
end
