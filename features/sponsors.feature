Feature:
	As an AgileVentures member
	In order to provide the best possible programming and collaboration tools for other AV members
	And in order to avoid monthly fees and subscription costs
	I would like to have saas companies sponsor AgileVentures and provide licenses for their products free of charge 
	And I would like to show our gratitude by displaying the sponsoring companies logotypes in a special section of AV website.
	Pivotal Tracker Story - https://www.pivotaltracker.com/story/show/64723776


  Background:
    Given the following projects exist:
      | title       | description          | status   |
      | hello world | greetings earthlings | active   |
      | hello mars  | greetings aliens     | inactive |

    And I am on the "Projects" page

	Scenario: See Sponsor Banners
		Then I should see sponsor banner for "Makers Academy"
		And I should see sponsor banner for "Agile Ventures"
		And I should see link "Become a supporter"

	Scenario: Click on "Become a supporter"
		When I click "Become a supporter"
		Then I am on the "supporters" page


