# frozen_string_literal: true

ab_test 'Landing page options' do
  description "Mirror, mirror on the wall, who's the better price of all?"
  alternatives 'text_trail', 'text_and_image_trail'
  metrics :signups, :premium_signups
end
