Feature:
  As a user
  So that I can edit static pages in github
  I would like to be able to have an edit button on the static pages thats 
  linked to the github repo

 Background:
   Given the following pages exist
      | title         | body                      |
      | About Us      | Agile Ventures            |
      | Sponsors      | AV Sponsors               |
      | Getting Started | Remote Pair Programming |
  And I am on the "home" page

 Scenario: There should be a link on the 'Sponsors' page to the github repo
 	Then I should see link "Becoming a sponsor"
 	When I click the 'Sponsors' page
 	Then I should be on 'Sponsors' page
 	Then I should see an 'Edit Page' button
 	Then 'Edit Page' should link to github edit page
 	