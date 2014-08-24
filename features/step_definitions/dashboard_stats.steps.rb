Then(/^I should see informative statistics about AgileVentures "(.*?)"$/) do |stat_subject|
  case stat_subject
    when "articles" then
      expect(page).to have_content('3 Articles Published')
    when "projects" then
      expect(page).to have_content('6 Active Projects') 
    when "users" then
      # is there an admin user created that bumps the count up by one? (expected 2 here)
      expect(page).to have_content('3 AgileVentures Members')
  end
end
