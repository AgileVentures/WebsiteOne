# frozen_string_literal: true

describe Article, type: :model do
  let(:user) { FactoryBot.create :user }
  subject { Article.new slug: 'test-article', user: user }

  it { is_expected.to respond_to :tag_list }
  it { is_expected.to respond_to :user }
  it { is_expected.to respond_to :friendly_id }
  it { is_expected.to respond_to :vote_value }
  it { is_expected.to respond_to :authored_by? }
  it { is_expected.to respond_to :create_activity }

  it 'has public-activity enabled' do
    expect(subject.public_activity_enabled?).to eq true
  end

  describe 'acts_as_votable' do
    it { is_expected.to respond_to :get_upvotes }
    it { is_expected.to respond_to :get_downvotes }
    it { is_expected.to respond_to :upvote_by }
    it { is_expected.to respond_to :downvote_by }
    it { is_expected.to respond_to :unvote_by }
    it { is_expected.to respond_to :vote_registered? }
  end

  describe '#url_for_me' do
    it 'returns correct url for show action' do
      expect(subject.url_for_me('show')).to eq '/articles/test-article'
    end

    it 'returns correct url for other actions' do
      expect(subject.url_for_me('new')).to eq '/articles/test-article/new'
    end
  end

  describe '#vote_value' do
    it 'returns the correct number of total value of votes' do
      downvotes = [ActsAsVotable::Vote.new, ActsAsVotable::Vote.new]
      upvotes = [ActsAsVotable::Vote.new]
      allow(subject).to receive(:get_upvotes).and_return(upvotes)
      allow(subject).to receive(:get_downvotes).and_return(downvotes)

      expect(subject.vote_value).to eq(-1)
    end
  end

  describe '#authored_by?' do
    it 'returns true if user passed matches the author' do
      expect(subject.authored_by?(subject.user)).to be_truthy
    end

    it 'returns false if user passed matches the author' do
      expect(subject.authored_by?(User.new)).to be_falsey
    end
  end
end
