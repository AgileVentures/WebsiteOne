require 'spec_helper'

describe KarmaCalculator do

  describe 'for new members' do
    subject { KarmaCalculator.new(user) }
    let(:user) { FactoryBot.build(:user, :without_karma, created_at: nil) }

    it 'should assign nil karma to members who have not yet been created' do
      expect(user.karma).to be_nil
    end
  end

  describe 'for new members without karma' do
    subject { KarmaCalculator.new(user) }
    let(:user) { FactoryBot.build(:user, :without_karma, created_at: nil) }

    it 'should assign nil karma to members without karma' do
      expect(user.karma).to be_nil
    end
  end

  context 'for existing members' do

    describe 'for old members' do
      subject { KarmaCalculator.new(user) }
      let(:user) { FactoryBot.build(:user, :with_karma, created_at: 31.days.ago) }
      let(:karma_points) { subject.perform; user.karma_total }

      it 'should assign karma points to members' do
        expect(karma_points).to be > 0
      end
    end

    describe 'for members attending hangouts' do
      let(:hangout) { FactoryBot.create(:event_instance) }
      # subject {  }
      let(:user) { FactoryBot.create(:user, :with_karma, created_at: 31.days.ago, gplus: hangout.participants.to_unsafe_h.first.last['person']['id']) }

      it 'gives points for hangout participation' do
        subject = KarmaCalculator.new(user)
        subject.perform
        expect(user.hangouts_attended_with_more_than_one_participant).to eq 1
      end
    end

  end
end

