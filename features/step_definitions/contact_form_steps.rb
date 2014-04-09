Then /^I should see "Contact us" form$/ do
  page.should have_css('form#contact_form')
  page.should have_text('Contact us')
end

Then /administrator should receive email with the message/ do
  expect(ActionMailer::Base.deliveries[0].body).to include('Love your site!')
end

Then /I should receive confirmation email/ do
  expect(ActionMailer::Base.deliveries[1].to[0]).to eq('ivan@petrov.com')
  expect(ActionMailer::Base.deliveries[1].body).to include('Thank you for your feedback')
end



