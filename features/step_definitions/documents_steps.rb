Given(/^the following documents exist:$/) do |table|
  temp_author = nil
  table.hashes.each do |hash|
    if hash[:project].present?
      hash[:project_id] = Project.find_by_title(hash[:project]).id
      hash.except! 'project'
    end
    if hash[:author].present?
      u = User.find_by_first_name hash[:author]
      hash.except! 'author'
      u.documents.create(hash)
    else
      if temp_author.nil?
        temp_author = User.create first_name: 'First',
                                  last_name: 'Last',
                                  email: "dummy#{User.count}@users.co",
                                  password: '1234124124'
      end
      temp_author.documents.create hash
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
When(/^I click the sidebar link "([^"]*)"$/) do |link|
  within('#sidebar') do
    click_link_or_button link
  end
end