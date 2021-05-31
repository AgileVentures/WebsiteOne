# frozen_string_literal: true

RSpec.describe KarmaCalculator do
  describe 'for new members' do
    subject { described_class.new(user) }
    let(:user) { build(:user, :without_karma, created_at: nil) }

    it 'should assign nil karma to members who have not yet been created' do
      expect(user.karma).to be_nil
    end
  end

  describe 'for new members without karma' do
    subject { described_class.new(user) }
    let(:user) { build(:user, :without_karma, created_at: nil) }

    it 'should assign nil karma to members without karma' do
      expect(user.karma).to be_nil
    end
  end

  context 'for existing members' do
    describe 'for old members' do
      subject { described_class.new(user) }
      let(:user) { build(:user, :with_karma, created_at: 31.days.ago) }
      let(:karma_points) { subject.calculate[:total] }

      it 'should assign karma points to members' do
        expect(karma_points).to be > 0
      end
    end

    describe 'for new members attending hangouts' do
      let(:user) { create(:user, :with_karma, created_at: 31.days.ago) }

      it 'event participation count is zero' do
        subject = described_class.new(user)
        expect(subject.calculate[:event_participation]).to eq 0
      end
    end
  end
end
