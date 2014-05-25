require 'spec_helper'

describe KarmaCalculator do
  subject { KarmaCalculator.new(user) }
  let(:user) { FactoryGirl.build(:user) }
  let(:karma_points) { subject.perform; user.karma_points }

  describe 'for new members' do
    let(:user) { FactoryGirl.build(:user, created_at: nil) }

    it 'should assign 0 karma points to members who have not yet been created' do
      expect(karma_points).to eq(0)
    end
  end

  describe 'for old members' do
    it 'should assign 0 karma points to members less than 1 month old' do
      user.created_at = 29.days.ago
      expect(karma_points).to eq(0)
    end

    it 'should assign karma points to members more than 1 month old' do
      user.created_at = 31.days.ago
      expect(karma_points).to be > 0
    end
  end
end
