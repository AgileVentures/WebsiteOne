require 'spec_helper'

describe Article do

  let(:article) { Article.new slug: "test-article" }

  it 'should respond to tag_list' do
    article.should respond_to :tag_list
  end

  it 'should respond to user' do
    article.should respond_to :user
  end

  it 'should respond to friendly_id' do
    article.should respond_to :friendly_id
  end

  describe '#url_for_me' do
    it 'returns correct url for show action' do
      article.url_for_me('show').should eq "/articles/#{article.slug}"
    end

    it 'returns correct url for other actions' do
      article.url_for_me('new').should eq "/articles/#{article.slug}/new"
    end
  end
end
