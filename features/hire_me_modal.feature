Feature: As a member of the Agile Ventures team
  To provide employment opportunities to team members
  We want to provide a "Hire Me" button for visitors to be able to contact members

  Background:
    Given the following users exist
      | first_name  | last_name   | email                   | display_profile |
      | Alice       | Jones       | alice@btinternet.co.uk  |     false       |
      | Bob         | Butcher     | bobb112@hotmail.com     |     true        |





 @javascript @selenium
 Scenario: Testing for the modal functionality
   Given I visit Bob's profile page
   When I click "Hire me"
   #And show me the page
   Then I should see a modal window with a form "Hire me form"
   When I fill in "f-name" with "Anonymous user"
   When I fill in "f-email" with "anonymous@isp.net"
   When I fill in "f-message" with "I want to hire you"
   When I click "Send message"
   #I should see a flash "message sent successfully"

   # message should be sent
   #app mailer
   #right routes form_for method


