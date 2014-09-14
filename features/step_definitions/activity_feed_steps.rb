Then(/^I should see a activity feed$/) do
  expect(page).to have_css('div#feed')
end

And(/^activities exists$/) do
 pending
end

And(/^I edit article "([^"]*)"$/) do |article|
  steps %Q{
    And I am on the "Show" page for article "#{article}"
    And I click the very stylish "Edit article" button
    Then I should be on the "Edit" page for article "#{article}"
    And I fill in "Content" with "**New content** ``New Markdown``"
    And I click the "Update" button
}
end