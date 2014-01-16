Given(/^the following documents exist:$/) do |table|
  table.hashes.each do |hash|
    project = Document.create(hash)
    project.save
  end
end

Then(/^I should be on documents page$/) do
  expect(current_path).to eq project_documents_path
end
Then(/^I should be on documents page for "([^"]*)"$/) do |title|
  id = Project.find_by_title(title).id
  expect(current_path).to eq project_documents_path(id)
end
Then(/I should be on "(.*?)" documents page for document "(.*?)"/) do |act, title|
  id = Document.find_by_title(title).id
  expect(current_path).to eq eval("#{act.downcase}_document_path(#{id})")
end

# TODO Bryan: pretty hackish way, possibly could use refactoring
When(/I click the "(.*?)" button for document "(.*?)"/) do |button, title|
  all(:xpath, '//tbody/tr').each do |elem|
    begin
      elem.find(:xpath, 'td', text: title)
      elem.click_link_or_button button
    rescue
      # do nothing
    end
  end
end
