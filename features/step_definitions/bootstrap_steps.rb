def path_to_css
  visit('/')
  link =  page.all(:xpath, '//head/link', visible: false).first[:href]
end

def path_to_js
  visit('/')
  link = page.all(:css, 'script', visible: false).first[:src]
end

Given /^the bootstrap library has been integrated into development server$/ do
  # if assets have been precompiled
  expect(Rails.root.join('public/javascripts/jquery.js').exist?).to be_true
  expect(Rails.root.join('public/assets/bootstrap').exist?).to be_true
end

Then /^I should see that bootstrap css library has been loaded$/ do
  # add css tags specific to bootstrap
  css_tags = %w[  viewport
                  carousel
                  img-responsive
                  container
                  table-striped
                  form-group
                  btn btn-default
                  img-rounded
                  center-block
                  clearfix
                  visible-xs
                ]
  visit(path_to_css)

  css_tags.each do |name|
    expect(page.html).to include(name)
  end
end

Then /^I should see that bootstrap js library has been loaded$/ do
  js_libraries = %w[
                  sizzle
                  jquery
                  jquery-ujs
                  affix
                  alert
                  button
                  carousel
                  collapse
                  dropdown
                  tab
                  transition
                  scrollspy
                  modal
                  tooltip
                  popover
                  bootstrap
                ]
  visit(path_to_js)

  js_libraries.each do |name|
    expect(page.html).to include(name)
  end
end

Then /^I should see that bootstrap is functioning$/ do
#  run bootstrap specific functions that change the DOM
#  if bootstrap is not loaded that the result will be 'is not a function'
  visit('/')
  expect(page.evaluate_script('$("").modal()')).to be_true
  expect(page.evaluate_script('$("").dropdown()')).to be_true
  expect(page.evaluate_script('$(this).scrollspy("refresh")')).to be_true
  expect(page.evaluate_script('$("").tab')).to be_true
  expect(page.evaluate_script('$("").tooltip()')).to be_true
  expect(page.evaluate_script('$("").popover')).to be_true
  expect(page.evaluate_script('$("").alert()')).to be_true
  expect(page.evaluate_script('$("").button()')).to be_true
  expect(page.evaluate_script('$("").collapse()')).to be_true
  expect(page.evaluate_script('$("").carousel()')).to be_true
  expect(page.evaluate_script('$("").affix()')).to be_true

end

Then /^I should see that jquery is functioning$/ do
#  run jquery specific functions that change the DOM
#  page.should have(change)
  expect(page.evaluate_script('jQuery.active')).to eq 0
end