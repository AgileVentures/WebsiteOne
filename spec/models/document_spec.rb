require 'spec_helper'

describe Document, :type => :model do
  subject { FactoryGirl.build_stubbed(:document) }

  it { is_expected.to be_versioned }
  it { is_expected.to respond_to :create_activity }

  it 'has public-activity enabled' do
    expect(subject.public_activity_enabled?).to eq true
  end

  it 'is valid with proper attributes' do
    expect(FactoryGirl.build(:document)).to be_valid
  end

  it 'is invalid without title' do
    expect(FactoryGirl.build(:document, title: '')).to_not be_valid
  end

  it 'is invalid without project' do
    expect(FactoryGirl.build(:document, project: nil)).to_not be_valid
  end

  describe '#url_for_me' do
    it 'returns correct url for show action' do
      expect(subject.url_for_me('show')).to eq "/projects/#{subject.project.slug}/documents/#{subject.slug}"
    end

    it 'returns correct url for other actions' do
      expect(subject.url_for_me('new')).to eq "/projects/#{subject.project.slug}/documents/#{subject.slug}/new"
    end
  end

  describe '#slug_candidates' do
    it 'returns correct slug candidates' do
      expect(subject.slug_candidates).to eq [ :title, [:title, :project_title] ]
    end
  end
end
