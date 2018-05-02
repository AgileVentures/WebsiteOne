Feature: Notify project creator when people join project
  As a project organizer/creator
  I want to be notified when new people join my project within the AV site
  so that I can reach out and personally welcome them
  
  Background:
    Given the following users exist
      | first_name | last_name | email                  | skill_list         | hangouts_attended_with_more_than_one_participant | id |
      | Alice      | Jones     | alicejones@hotmail.com | ruby, rails, rspec |  1                                               | 1  |
      | John       | Doe       | john@doe.com           | ruby, rails, rspec |  nil                                             |    |
      | Bryan      | Yap       | test@test.com          |                    |                                                  |    |
    Given the following projects exist:
      | title         | description             | pitch       | status   | github_url                                  | pivotaltracker_url                               | commit_count | user_id |
      | hello world   | greetings earthlings    |             | active   | https://github.com/AgileVentures/WebsiteOne | https://www.pivotaltracker.com/s/projects/742821 | 2795         | 2       |
  
  Scenario: when a person joins project an email is sent to project creator
    Given I am logged in as "John"
    And I go to the "hello world" project "show" page
    When I click "Join Project"
    Then "hello world" project creator should receive a "John Doe just joined hello world project" email containing "john@doe.com just joined your project hello world, you can reach out and personally welcome them."

  Scenario: Allow project creator to adjust their email preferences for project joins
    Given I am logged in as "Alice"
    And I click on the avatar for "Alice"
    When I click the "Edit" button
    And I uncheck "Receive site emails"
    Given I sign out
    When I am logged in as "Bryan"
    And I go to the "hello world" project "show" page
    When I click "Join Project"
    Then "hello world" project creator should not receive a "Bryan Yap just joined hello world project" email
