And /^I should see "Contact us" form in footer$/ do
  within('section#footer') do
    page.should have_css('form#contact_form')
    page.should have_text('Contact us')
  end

end

