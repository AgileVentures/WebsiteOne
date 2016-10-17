require 'spec_helper'

describe KarmaCalculator do

  describe 'for new members' do
    subject { KarmaCalculator.new(user) }
    let(:user) { FactoryGirl.build(:user, created_at: nil) }
    let(:karma_points) { subject.perform; user.karma_total }

    it 'should assign 0 karma points to members who have not yet been created' do
      expect(karma_points).to eq(0)
    end
  end

  context 'for existing members' do

    describe 'for old members' do
      subject { KarmaCalculator.new(user) }
      let(:user) { FactoryGirl.build(:user, created_at: 31.days.ago) }
      let(:karma_points) { subject.perform; user.karma_total }


      it 'should assign karma points to members' do
        expect(karma_points).to be > 0
      end
    end

    describe 'for members attending hangouts' do
      let(:hangout) { FactoryGirl.create(:event_instance) }
      # subject {  }
      let(:user) { FactoryGirl.create(:user, created_at: 31.days.ago, gplus: hangout.participants.first.last['person']['id']) }

      it 'gives points for hangout participation' do
        subject = KarmaCalculator.new(user)
        subject.perform
        expect(user.hangouts_attended_with_more_than_one_participant).to eq 1
      end
    end

  end
end

