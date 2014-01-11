Then(/^I should see a "([^"]*)" table$/) do |legend|
  within('table#projects') do
    page.should have_css('legend', :text => legend)
  end
end

When(/^I should see column (.*)$/) do |column|
  within('table#projects thead') do
    page.should have_css('th', :text => column)
  end
end

When(/^I should see button (.*)$/) do |link|
  within('table#projects') do
    page.should have_link link
  end
end

When(/^There are projects in the database$/) do
  #TODO Y use factoryGirl
  Project.create(title: "Title 1", description: "Description 1", status: "Status 1")
  Project.create(title: "Title 2", description: "Description 2", status: "Status 2")
end
