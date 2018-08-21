Feature: Provide a token for av dashboard
    As an AV Dashboard user
    So that I can gain access to user data
    I should be provided with an access token

  Scenario: Logged in authorized user requests a token
    Given I have logged in as a user who is authorized to view the AVDashboard
    When I go to the "av dashboard token" page
    Then I should have a valid authorized AVDashboard token on the rendered page

  Scenario: Logged in but unauthorized user requests a token
    Given I have logged in as a user who is not authorized to view the AVDashboard
    When I go to the "av dashboard token" page
    Then I should have a valid unauthorized AVDashboard token on the rendered page

  Scenario: Non-logged in authorized user requests a token
    Given I exist as a user who is authorized to view the AVDashboard
    And I go to the "av dashboard token" page
    Then I should be on the "sign in" page
    When I sign in with valid credentials
    Then I should be on the "av dashboard token" page
    And I should have a valid authorized AVDashboard token on the rendered page

  Scenario: Non-logged in unauthorized user requests a token
    Given I exist as a user who is not authorized to view the AVDashboard
    And I go to the "av dashboard token" page
    Then I should be on the "sign in" page
    When I sign in with valid credentials
    Then I should be on the "av dashboard token" page
    And I should have a valid unauthorized AVDashboard token on the rendered page
