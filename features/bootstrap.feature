Feature: Bootstrap framework to provide modern UX
  @javascript
  Scenario: The Bootstrap framework is loaded
   Given the bootstrap library has been integrated into development server

   When I go to the "home" page

   Then I should see that bootstrap css library has been loaded
   And I should see that bootstrap js library has been loaded

   And I should see that bootstrap is functioning
   And I should see that jquery is functioning


