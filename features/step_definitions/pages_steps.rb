Then /^I (am|should be) on the static "([^"]*)" page$/ do |option, page|
  path = page_path page.downcase.squish.gsub(/\s+/,'-')
  case option
    when 'am'
      visit path

    when 'should be'
      expect(current_path).to eq path

    else
      pending
  end
end


