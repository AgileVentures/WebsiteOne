@rake
Feature: Create the Plans
  As the admin
  So that users can get premium related functionality
  I want the plans to be in the database

  Scenario: Create the premium plans
    When I run the rake task for creating plans
    Then there should be a "Premium" subscription plan
    And there should be a "Premium Plus" subscription plan
    And there should be a "Premium Mob" subscription plan
    And there should be a "Premium F2F" subscription plan
