Feature: Rendering contact us form
  So that I can receive feedback from users
  As a site administrator
  I would like to display a "contact us" form on the sites index(landing page)
  https://www.pivotaltracker.com/story/show/63103292

  Add functionality to add a contact us form to index page in #footer

  Background:
    Given I visit the site

  Scenario: Rendering contact us form
    Then I should see a footer area
    And I should see "Contact us" form within the footer
    And I should see "Send a traditional email to info@agileventures.org, or use the contact form."
    And I should see link "info@agileventures.org"

  Scenario: Contact form contents
    And I should see a form "Contact form" with:
      | Field                 |                     |
      | Name                  |                     |
      | Email                 |                     |
      | Message               |                     |
    And I should see button "Send message"

  Scenario: Sending a message (valid inputs)
    Given I fill in "Contact form":
      | Field                 | Contents                        |
      | Name                  | Ivan Petrov                     |
      | Email                 | ivan@petrov.com                 |
      | Message               | New message from Ivan Petrov    |
    And I click the "Send message" button
    Then I should see "Your message has been sent successfully!"

  Scenario: Sending a message (invalid inputs: no message)
    Given I fill in "Contact form":
      | Field                 | Contents                        |
      | Name                  | Ivan Petrov                     |
      | Email                 |                                 |
      | Message               |                                 |
    And I click the "Send message" button
    Then I should see "Please, fill in Name and Message field"

  Scenario: Sending a message (invalid inputs: no name)
    Given I fill in "Contact form":
      | Field                 | Contents                        |
      | Name                  |                                 |
      | Email                 |                                 |
      | Message               | I love your site!               |
    And I click the "Send message" button
    Then I should see "Please, fill in Name and Message field"

  Scenario: Receiving the message
    Given I fill in "Contact form":
      | Field                 | Contents                        |
      | Name                  | Ivan Petrov                     |
      | Message               | Love your site!                 |
    And I click the "Send message" button
    Then administrator should receive email with the message

  Scenario: Receiving the message with confirmation
    Given I fill in "Contact form":
      | Field                 | Contents                        |
      | Name                  | Ivan Petrov                     |
      | Email                 | ivan@petrov.com                 |
      | Message               | Love your site!                 |
    And I click the "Send message" button
    Then I should receive confirmation email
    And administrator should receive email with the message



