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

# Bryan: replaced with more general approach
#Then(/^I should be on the documents page for project "([^"]*)"$/) do |title|
#  id = Project.find_by_title(title).id
#  expect(current_path).to eq project_documents_path(id)
#end

# Bryan: replaced with more general approach
#Then(/I should be on "([^"]*)" documents page for document "([^"]*)"/) do |action, title|
#  id = Document.find_by_title(title).id
#  action = action.downcase.singularize
#  p
#  if action == 'show'
#    expect(current_path).to eq document_path(id)
#  else
#    expect(current_path).to eq eval("#{action}_document_path(#{id})")
#  end
#end

# TODO Bryan: pretty hackish way, possibly could use refactoring
#When(/I click the "([^"]*)" button for document "([^"]*)"/) do |button, title|
#  all(:xpath, '//tbody/tr').each do |elem|
#    begin
#      elem.find(:xpath, 'td', text: title)
#      elem.click_link_or_button button
#    rescue
#      # do nothing
#    end
#  end
#end

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

#When(/^I should see a link to "([^"]*)" page for document "([^"]*)"$/) do |action, title|
#  id = Document.find_by_title(title).id
#  action = action.downcase.singularize
#  # TODO figure out why this always returns www.example.com
#  p url_for(controller: :documents, action: action, id: id)
#  if action == 'show'
#    expected_path = document_path(id)
#  else
#    expected_path = eval("#{action}_document_path(#{id})")
#  end
#  page.has_link?(action, href: expected_path)
#end

Then(/^I should be in the Mercury Editor$/) do
  expect(current_path).to match(/\/editor\//i)
end

When(/^I am using the Mercury Editor to edit ([^"]*) "([^"]*)"$/) do |model, title|
  #Capybara.current_driver = :selenium
  visit "/editor#{url_for_title(action: 'show', controller: model, title: title)}"
end

# Bryan: not completely reliable but works for the time being
Then(/^I should see the editable field "([^"]*)"$/) do |field|
  find(:css, "div#document_#{field.downcase.singularize}[contenteditable]")
end

When /^(?:|I )click "([^"]*)" within the Mercury Editor toolbar$/ do |button|
  selector_for = {
      'save' => 'mercury-save-button'
  }
  page.execute_script("$('.#{selector_for[button.downcase]}').click()")
  p 'sleep(0.1)'
  sleep(0.1)
end

Then(/(.*) within the content frame$/) do |s|
  page.driver.within_frame('mercury_iframe') { step(s) }
end

Given(/^I am going to use the Mercury editor/) do
  Capybara.current_driver = :selenium
end
