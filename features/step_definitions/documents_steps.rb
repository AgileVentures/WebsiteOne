Given(/^the following documents exist:$/) do |table|
  table.hashes.each do |hash|
    project = Document.create(hash)
    project.save
  end
end

Then(/^I should be on documents page$/) do
  expect(current_path).to eq path_to(project_documents_path)
end
