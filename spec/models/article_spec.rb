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

  it 'should respond to get_upvotes' do
    expect(article).to respond_to :get_upvotes
  end

  it 'should respond to get_downvotes' do
    expect(article).to respond_to :get_downvotes
  end

  it 'should respond to vote_value' do
    expect(article).to respond_to :vote_value
  end

  it 'should respond to upvote_by' do
    expect(article).to respond_to :upvote_by
  end

  it 'should respond to downvote_by' do
    expect(article).to respond_to :downvote_by
  end

  it 'should respond to unvote_by' do
    expect(article).to respond_to :unvote_by
  end

  it 'should respond to vote_registered?' do
    expect(article).to respond_to :vote_registered?
  end

end
