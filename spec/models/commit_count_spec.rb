require 'spec_helper'

describe CommitCount, type: :model do
  subject { build_stubbed :commit_count }

  it 'should be valid with all the correct attributes' do
    expect(subject).to be_valid
  end

  it 'should be invalid without user' do
    expect(build_stubbed(:commit_count, user: nil)).to_not be_valid
  end

  it 'should be invalid without project' do
    expect(build_stubbed(:commit_count, project: nil)).to_not be_valid
  end

  it 'should be invalid without commit_count' do
    expect(build_stubbed(:commit_count, commit_count: nil)).to_not be_valid
  end

  it 'should be invalid with duplicate record (same user and same project)' do
    commit_count = FactoryGirl.create(:commit_count)
    expect(build(:commit_count, user: commit_count.user,  project: commit_count.project)).to_not be_valid
  end
end
