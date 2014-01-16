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