@vcr
Feature: Update karma points of all users
  As a website admin, i should be able to update
  total karma points of my members

  Background:
    Given a gplus user who has attended one event

  Scenario: Update github commit count of all projects with valid github_url
    When I run rake task "karma_calculator"
    Then the gplus user should be credit as having attended one event