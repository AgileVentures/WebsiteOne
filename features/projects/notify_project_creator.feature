Feature: Notify project creator when people join project
  As a project organizer/creator
  I want to be notified when new people join my project within the AV site
  so that I can reach out and personally welcome them
  
  Background:
    Given the following projects exist:
      | title         | description             | pitch       | status   | github_url                                  | pivotaltracker_url                               | commit_count |
      | hello world   | greetings earthlings    |             | active   | https://github.com/AgileVentures/WebsiteOne | https://www.pivotaltracker.com/s/projects/742821 | 2795         |
  
  Scenario: when a person joins project an email is sent to project creator
    Given I am logged in
    And I go to the "hello world" project "show" page
    When I click "Join Project"
    Then "hello world" project creator should receive a "New member in hello world project" email containing ""
