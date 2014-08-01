require 'spec_helper'

describe Article, :type => :model do

  subject { Article.new slug: 'test-article' }

  it { is_expected.to respond_to :tag_list}
  it { is_expected.to respond_to :user}
  it { is_expected.to respond_to :friendly_id}

  it 'should respond to acts_as_votable methods' do
    expect(subject).to respond_to :get_upvotes
    expect(subject).to respond_to :get_downvotes
    expect(subject).to respond_to :upvote_by
    expect(subject).to respond_to :downvote_by
    expect(subject).to respond_to :unvote_by
    expect(subject).to respond_to :vote_registered?
  end

  it 'should respond to vote_value' do
    expect(subject).to respond_to :vote_value
  end

  it 'should respond to authored_by?' do
    expect(subject).to respond_to :authored_by?
  end

  describe '#url_for_me' do
    it 'returns correct url for show action' do
      expect(subject.url_for_me('show')).to eq "/articles/test-article"
    end

    it 'returns correct url for other actions' do
      expect(subject.url_for_me('new')).to eq "/articles/test-article/new"
    end
  end
end
