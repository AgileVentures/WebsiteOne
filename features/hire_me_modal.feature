Feature: As a member of the Agile Ventures team
  To provide employment opportunities to team members
  We want to provide a "Hire Me" button for visitors to be able to contact members

  Background:
    Given the following users exist
      | first_name  | last_name   | email                   | display_profile |
      | Alice       | Jones       | alice@btinternet.co.uk  |     false       |
      | Bob         | Butcher     | bobb112@hotmail.com     |     true        |

 @javascript @selenium
 Scenario: Sending a message to user with 'Hire me' button
   Given I visit Bob's profile page
   When I click "Hire me"
   Then I should see a modal window with a form "Contact Bob Butcher"
   And I fill in "f-name" with "Anonymous user"
   And I fill in "f-email" with "anonymous@isp.net"
   And I fill in "f-message" with "I want to hire you"
   And I click the "Send message" button
   Then The user should receive a "message from Anonymous user" email
   Then I should see "Your message has been sent successfully!"


