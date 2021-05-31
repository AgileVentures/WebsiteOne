# frozen_string_literal: true

And(/^stats for "([^"]*)" should be "([^"]*)"$/) do |stat, value|
  within "##{stat.downcase}" do
    expect(page).to have_css 'div.panel-heading', text: stat
    expect(page).to have_css 'div.panel-body', text: value
  end
end
