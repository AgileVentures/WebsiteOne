require 'spec_helper'
# from https://gist.github.com/timocratic/5113293

describe UriValidator do
  subject do
    Test = Class.new do
      include ActiveModel::Validations
      attr_accessor :url
      validates :url, uri: true
    end
    Test.new
  end

  it 'should be valid for a valid http url' do
    subject.url = 'http://www.google.com'
    subject.valid?
    subject.errors.full_messages.should == []
  end
  ['http:/www.google.com','<>hi'].each do |invalid_url|
    it "#{invalid_url.inspect} is an invalid url" do
      subject.url = invalid_url
      subject.valid?
      subject.errors.should have_key(:url)
    end
  end
end