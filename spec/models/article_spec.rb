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
end
