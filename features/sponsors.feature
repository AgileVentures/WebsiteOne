Feature:
	As an AgileVentures member
	In order to provide the best possible programming and collaboration tools for other AV members
	And in order to avoid monthly fees and subscription costs
	I would like to have saas companies sponsor AgileVentures and provide licenses for their products free of charge 
	And I would like to show our gratitude by displaying the sponsoring companies logotypes in a special section of AV website.
	Pivotal Tracker Story - https://www.pivotaltracker.com/story/show/64723776

	Background: 
		#Given I am not on the home page
		Given I am on the "Projects" page

	Scenario: See Sponsor Banners
		Then I should to see sponsor banner for "sponsor 1"
		And I should to see sponsor banner for "sponsor 2"
		And I should to see link "Become a sponsor"