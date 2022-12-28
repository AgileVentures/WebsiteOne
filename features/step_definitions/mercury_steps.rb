# frozen_string_literal: true

When /^(?:|I )click "([^"]*)" within Mercury Editor toolbar$/ do |button|
  selector_for = {
    'save' => 'mercury-save-button'
  }
  page.execute_script("$('.#{selector_for[button.downcase]}').click()")
  wait_for_ajax
end

# When(/^I fill in the editable field "([^"]*)" for "([^"]*)" with "([^"]*)"$/) do |field, type, s|
#   page.driver.within_frame('mercury_iframe') do
#     field = field.downcase.singularize
#     # This selector is specific to the mercury region used!
#     case field
#     when 'title'
#       find(:css, "div##{type}_title>textarea").set(s)
#     when 'body'
#       page.execute_script("$('##{type}_body').text('#{s}')")
#     when 'pitch'
#       find(:css, '#pitch_content').set(s)
#     end
#   end
# end

Then(/^I should be in the Mercury Editor$/) do
  expect(current_path).to match(%r{/editor/}i)
end

When(/^I (try to use|am using) the Mercury Editor to edit ([^"]*) "([^"]*)"$/) do |_opt, model, title|
  visit "/editor#{url_for_title(action: 'show', controller: model, title: title)}"
end

When(/^I try to edit the page$/) do
  visit "/editor#{current_path}"
end

# Then /^I should( not)? see button "([^"]*)" in Mercury Editor$/ do |negative, button|
#   button = 'new_document_link' if button == 'New document'
#   page.driver.within_frame('mercury_iframe') do
#     if negative
#       expect(has_link?(button)).to be_falsey
#     else
#       expect(has_link?(button)).to be_truthy
#     end
#   end
# end

# When /I click "([^"]*)" in Mercury Editor/ do |button|
#   page.execute_script('Mercury.silent = true')   # disabling the confirmation dialog for saving changes
#   page.driver.within_frame('mercury_iframe') do
#     click_link button
#   end
# end

When(/^I click on the "Insert Media" button$/) do
  find(:css, '.mercury-primary-toolbar .mercury-insertMedia-button').click
  sleep 1
end

Then(/^the Mercury Editor modal window should (not |)be visible$/) do |visible|
  expect(page).to have_css '.mercury-modal', visible: visible.blank?
end

And(/^I am focused on the "([^"]*)"$/) do |item|
  item.downcase!
  case item
  when 'document body'
    page.execute_script '$("#document_body").focus();'

  else
    pending
  end
end
