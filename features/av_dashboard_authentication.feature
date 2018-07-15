Feature: Provide a token for av dashboard
    As an AV Dashboard user
    So that I can gain access to user data
    I should be provided with an access token

  Scenario: Logged in user requests a token
    Given I have logged in
    When I go to the "av dashboard token" page
    Then I should have a valid authorized AVDashboard token on the rendered page
