@omniauth
Feature: As a site user
  So I can connect and disconnect my YouTube channel
  I would like to have actions to connect and disconnect

  Background:
    Given I am logged in

  Scenario: Show 'link your channel' message if my page channel is not linked
    Given my YouTube Channel is not connected
    When I go to my "edit profile" page
    And I should see "Sync with YouTube"

  Scenario: Show 'unlink your channel' message if my channel is connected
    Given my YouTube channel is connected
    When I go to my "edit profile" page
    Then I should see "Disconnect YouTube"

  Scenario: Link my Youtube channel to my account
    Given my YouTube Channel is not connected
    And I am on my "edit profile" page
    When I click "Sync with YouTube"
    Then I should see "Disconnect YouTube"
    But I should not see "Sync with YouTube"

  Scenario: Unlink my Youtube channel
    Given my YouTube channel is connected
    And I am on my "edit profile" page
    When I click "Disconnect YouTube"
    Then I should see "Sync with YouTube"
    But I should not see "Disconnect YouTube"

