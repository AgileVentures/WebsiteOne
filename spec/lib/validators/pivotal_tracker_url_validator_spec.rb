require 'spec_helper'

class DummyUrlValidatorClass
  include ActiveModel::Validations
  attr_accessor :pivotaltracker_url
  validates_with PivotalTrackerUrlValidator
end

describe PivotalTrackerUrlValidator do
  subject { DummyUrlValidatorClass.new }

  it 'should be valid for a valid pivotal project url' do
    subject.pivotaltracker_url = 'https://www.pivotaltracker.com/s/projects/982890'
    subject.valid?
    subject.errors.full_messages.should == []
  end

  ['http://github.com/AgileVentures/WebsiteOne','<>hi'].each do |invalid_url|
    it "#{invalid_url.inspect} is an invalid url" do
      subject.pivotaltracker_url = invalid_url
      subject.valid?
      subject.errors.should have_key(:pivotaltracker_url)
    end
  end
end
