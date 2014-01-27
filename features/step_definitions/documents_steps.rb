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

#| Howto         | How to start     |          2 | 55 |     33    |
#| Another doc   | My content       |          2 | 66 |     33    |
#| Howto 2       | My documentation |          1 | 77 |     44    |


#When(/^I click the "([^"]*)" button for project "([^"]*)"$/) do |button, project_name|
#  project = Project.find_by_title(project_name)
#  if project
#    within("tr##{project.id}") do
#      click_link_or_button button
#    end
#  else
#    visit path_to(button, 'non-existent')
#  end
#end