# frozen_string_literal: true

Given(/^Feature "([^"]*)" is (enable|disable)d$/) do |feature_name, state|
  Features.send(state, feature_name.underscore.to_sym)
end
