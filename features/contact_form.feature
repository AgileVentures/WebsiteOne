Feature: Rendering contact us form
  So that I can receive feedback from users
  As a site administrator
  I would like to display a "contact us" form on the sites index(landing page)
  https://www.pivotaltracker.com/story/show/63103292

  Add functionality to add a contact us form to index page in #footer

  Background:
    Given I visit the site

  Scenario: Load contact us form
    Then I should see a footer area
    And I should see "Contact us" form in footer

  Scenario: Contact form contents
    And I should see a form with:
      | Name                  |                     |
      | Email                 |                     |
      | Message               |                     |
    And I should see button "Send message"


  Scenario: Sending a message
    Given I fill in:
      | Name                  | John Doe                        |
      | Email                 | johndoe@gmail.com               |
      | Message               | New message from John Doe       |
    And I click the "Send message" button
    Then I should see "Your message has been sent successfully"

  Scenario: Receiving the message
    Given I have sent the message with "New message from Ivan Petrov"
    Then I should receive confirmation email
    And administrator should receive email with my message




