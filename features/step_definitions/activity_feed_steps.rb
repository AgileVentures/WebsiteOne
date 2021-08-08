# frozen_string_literal: true

Then(/^I should see a activity feed$/) do
  expect(page).to have_css('div#feed')
end

And(/^I edit article "([^"]*)"$/) do |article|
  steps %(
    And I am on the "Show" page for article "#{article}"
    And I click the very stylish "Edit article" button
    Then I should be on the "Edit" page for article "#{article}"
    And I fill in "Content" with "**New content** ``New Markdown``"
    And I click the "Update" button
)
end

And(/^I create a document named "([^"]*)"$/) do |document|
  steps %( Given I am on the "Show" page for project "Hello Galaxy"
            And I click the "Join Project" button
            And I click "Project Actions"
            And I click "Create new document"
            And I fill in "Title" with "#{document}"
            And I click "Submit"
)
end

And(/^I create a project named "([^"]*)"$/) do |project|
  steps %{
    Given The project has no stories on Pivotal Tracker
    And I am on the "Projects" page
    And I click the very stylish "New Project" button
    When I fill in:
      | Field                     | Text                                            |
      | Title                     | #{project}                                      |
      | Description               | Description New                                 |
      | GitHub url (primary)      | http://www.github.com/abc                       |
      | Issue Tracker (primary)   | http://www.pivotaltracker.com/s/projects/982890 |
    And I click the "Submit" button
}
end

Given(/^Given I am on the Activity feed$/) do
  steps %(
    Given I am on the "Dashboard" page
    And I click the "Activity feed" link
)
end
