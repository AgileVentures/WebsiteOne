And /^I should receive a "(.*?)" email$/ do |arg1|
  @email = ActionMailer::Base.deliveries.last
  @email.subject.should include(arg1)
  ActionMailer::Base.deliveries.size.should eq 1
end

And /^I should not receive an email$/ do
  ActionMailer::Base.deliveries.size.should eq 0
end

And /^the email queue is clear$/ do
  ActionMailer::Base.deliveries.clear
end
