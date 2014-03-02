Feature: As a member of the Agile Ventures team
  To provide employment opportunities to team members
  We want to provide a "Hire Me" button for visitors to be able to contact members

  Background:
    Given the following users exist
      | first_name  | last_name   | email                   | display_profile |
      | Alice       | Jones       | alice@btinternet.co.uk  |     false       |
      | Bob         | Butcher     | bobb112@hotmail.com     |     true        |


#  Scenario: Checking for modal toggle
#    Given I visit Bob's profile page
#    Then I should not see a modal
#    When I click "Hire me"
#    a pop up should come up
#    and I should enter the data in the fields
#    I will click on submit
#    Then I should see a modal



#  background do
#  visit '/'
#  click_on '+'
#  fill_in 'title', :with => $a_title
#  fill_in 'issued', :with => '1885'
#  select 'invitation', :from => 'aeresType'
#  click_on 'Enregistrer'
#  end
#
#  scenario 'for any record' do
#  click_on 'Supprimer...'
#  page.should have_content 'Voulez-vous supprimer cette notice ?'
#  in_dialog.click_button 'Supprimer'
#  wait_until_dialog_closed
#  page.should have_content 'Publications (références)'
#  page.should_not have_content $a_title
#  endbackground do

 @javascript
 Scenario: Testing for the modal functionality
   Given I visit Bob's profile page
   When I click "Hire me"
   And show me the page
   Then I should see a modal window with a form "Hire me form"

#   And I fill in field first name with "Bob"
#   And I fill in field last name with "Butcher"
#   And I fill in field email with "bobb112@hotmail.com"
#   And I fill in field message with "I want to hire you"
#   When I click "Send Message"


