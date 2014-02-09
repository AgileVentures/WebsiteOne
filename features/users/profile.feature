Feature: As a user of the site
	In order to get to know other users
	I want to be able to view a user profile page with information about the user.

	Background:
	  Given I am on the "home" page
	  And the following users exist
	    | first_name  | last_name   | email                   | password  |
	    | Alice       | Jones       | alice@btinternet.co.uk  | 12345678  |
	    | Bob         | Butcher     | bobb112@hotmail.com     | 12345678  |
	    # |             | Croutch     | c.croutch@enterprise.us | 12345678  |
	    # | Dave        |             | dave@dixons.me          | 12345678  |
    And the following projects exist:
      | title         | description             | status   |
      | hello world   | greetings earthlings    | active   |
      | hello mars    | greetings aliens        | inactive |
      | hello jupiter | greetings jupiter folks | active   |
      | hello mercury | greetings mercury folks | inactive |
      | hello saturn  | greetings saturn folks  | active   |
      | hello sun     | greetings sun folks     | active   |
	  And I am logged in as user with email "brett@example.com", with password "12345678"
	  And I am on the "Our members" page

	Scenario: Having user profile page
    #  We should be able to test this by setting user joined 1 month ago
    #  rather than tying to stub the current date
    # And user "Alice" has joined on "01/01/2014"
    # And today is "07/02/2014"
    When I click on the avatar for "Alice"
    Then I should be on the "user profile" page for "Alice"
    And I should see the avatar for "Alice" at 275 px
    And I should see "Alice Jones"
    # And I should see "Member for: about 1 month"
    And I should see "Member for:"

  Scenario: Having edit button on the profile page
    When I click on the avatar for "brett@example.com"
    Then I should be on the "user profile" page for "brett@example.com"
    And I should see button "Edit"
    And I click the "Edit" button
    And I should be on the "my account" page

  Scenario: Not seeing an edit button on others profile pages
    When I click on the avatar for "Bob"
    And I should not see button "Edit"

  Scenario: Having a list of followed projects on my profile page
  	Given user "Bob" follows projects:
  	| title         | description             | status   |
  	| hello world   | greetings earthlings    | active   |
  	# | hello mars    | greetings aliens        | inactive |
  	| hello jupiter | greetings jupiter folks | active   |
  	When I click "Bob Butcher"
  	Then I should be on the "user profile" page for "Bob"
  	And I should see:
  	| title			|
  	| hello world 	|
  	| hello jupiter |



