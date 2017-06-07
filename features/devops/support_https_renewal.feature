Feature: Support HTTPS renewal
  As the admin
  So that users will trust our site
  I want the HTTPS to be supported and be able to be renewed when required

  Scenario: Create the premium plans
    When I hit the letsencrypt endpoint
    Then I should receive the correct challenge response
