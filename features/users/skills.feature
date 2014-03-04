Feature: As a site user
    In order to find a user with a relevant skill
    I would like to see a users self assessed skills set

	Background:
      Given I am on the "home" page
	  And the following users exist
      | first_name  | last_name   | email                   | skills                 |
      | Alice       | Jones       | alicejones@hotmail.com  | rails,cucumber,rspec   |
      | Bob         | Butcher     | bobb112@hotmail.com     |                        |
	  And I am logged in as user with email "brett@example.com", with password "12345678"

	Scenario: Can add skills to my profile
      Given I am on my "edit profile" page
      And I click the "Edit" button
      And I type in skills "c++,java,php"
      And I click "Update"
      When I click on the avatar for "brett@example.com"
      Then I should be on the "user profile" page for "brett@example.com"
      And I should see skills "c++,java,php"

    Scenario: Can see user skills on users index page
      Given I am on the "our members" page
      Then I should see skills "rails,cucumber,rspec" for "alicejones@hotmail.com"