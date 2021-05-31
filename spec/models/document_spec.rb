# frozen_string_literal: true

RSpec.describe Document, type: :model do
  subject { build_stubbed(:document) }

  it { is_expected.to be_versioned }
  it { is_expected.to respond_to :create_activity }

  it 'is expected to have public-activity enabled' do
    expect(subject.public_activity_enabled?).to eq true
  end

  describe 'factories' do
    it 'is expected to be valid with proper attributes' do
      expect(build(:document)).to be_valid
    end

    it 'is expected to be is invalid without title' do
      expect(build(:document, title: '')).to_not be_valid
    end

    it 'is expected to be invalid without project' do
      expect(build(:document, project: nil)).to_not be_valid
    end
  end

  describe '#url_for_me' do
    it 'is expected to return correct url for show action' do
      expect(subject.url_for_me('show'))
        .to eq "/projects/#{subject.project.slug}/documents/#{subject.slug}"
    end

    it 'is expected to be return correct url for other actions' do
      expect(subject.url_for_me('new'))
        .to eq "/projects/#{subject.project.slug}/documents/#{subject.slug}/new"
    end
  end

  describe '#slug_candidates' do
    it 'is expected to return correct slug candidates' do
      expect(subject.slug_candidates)
        .to eq [:title, %i(title project_title)]
    end
  end
end
