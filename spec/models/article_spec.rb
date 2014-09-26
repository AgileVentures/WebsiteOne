require 'spec_helper'

describe Article do

  let(:article) { Article.new }

  it 'should respond to tag_list' do
    expect(article).to respond_to :tag_list
  end

  it 'should respond to user' do
    expect(article).to respond_to :user
  end

  it 'should respond to friendly_id' do
    expect(article).to respond_to :friendly_id
  end

  it 'should respond to acts_as_votable methods' do
    expect(article).to respond_to :get_upvotes
    expect(article).to respond_to :get_downvotes
    expect(article).to respond_to :upvote_by
    expect(article).to respond_to :downvote_by
    expect(article).to respond_to :unvote_by
    expect(article).to respond_to :vote_registered?
  end

  it 'should respond to vote_value' do
    expect(article).to respond_to :vote_value
  end

  it 'should respond to authored_by?' do
    expect(article).to respond_to :authored_by?
  end

end
