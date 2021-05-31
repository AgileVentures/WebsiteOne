# frozen_string_literal: true

RSpec.describe Plan, type: :model do
  describe '#free_trial?' do
    it 'has a free trial when the length of the free trial is greater than 0 days' do
      plan = Plan.new(free_trial_length_days: 6)
      expect(plan).to be_free_trial
    end
  end
end
