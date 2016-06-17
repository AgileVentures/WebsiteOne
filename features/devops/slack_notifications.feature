Feature: Slack Service
  As a site admin
  So that users can join in each others pairing sessions
  I would like them to be aware of each others activity

  Scenario: Slack Notifications
    Given that Slack Notifications are enabled
    And that the Agile Bot URL is set correctly
    When I start a hangout
    Then there should be an appropriate notification in slack