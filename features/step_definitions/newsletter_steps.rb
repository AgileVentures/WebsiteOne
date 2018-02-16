Given /^the following newsletters exist$/ do |table|
  table.hashes.each do |attributes|
    FactoryBot.create(:newsletter, attributes)
  end
end

Given /^I visit unsent newsletter$/ do
  visit newsletter_path(Newsletter.where(was_sent: false).first)
end
