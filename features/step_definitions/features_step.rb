Given(/^Feature "([^"]*)" is (enable|disable)d$/) do |feature_name, state|
  Features.send(state, feature_name.underscore)
end
