Then /^I should see "Contact us" form in footer$/ do
  within('section#footer') do
    page.should have_css('form#contact_form')
    page.should have_text('Contact us')
  end
end

Then /administrator should receive email with the message/ do
  expect(ActionMailer::Base.deliveries[1].body).to include('Thank you for your feedback')

end

Then /I should receive confirmation email/ do
  expect(ActionMailer::Base.deliveries[1].body).to include('Thank you for your feedback')

end



