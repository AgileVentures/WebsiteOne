# frozen_string_literal: true

RSpec.describe CommitCount, type: :model do
  subject { build_stubbed :commit_count }

  it 'should have a valid factory' do
    expect(subject).to be_valid
  end

  context 'without a user' do
    before { subject.user = nil }
    it { is_expected.to_not be_valid }
  end

  context 'without a project' do
    before { subject.project = nil }
    it { is_expected.to_not be_valid }
  end

  context 'without a commit count' do
    before { subject.commit_count = nil }
    it { is_expected.to_not be_valid }
  end

  context 'with a duplicate record having same user and project' do
    let(:duplicate_record) { create(:commit_count) }
    subject { build(:commit_count, duplicate_record.attributes) }
    it { is_expected.to_not be_valid }
  end
end
