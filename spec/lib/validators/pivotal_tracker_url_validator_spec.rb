require 'spec_helper'


describe PivotalTrackerUrlValidator do
  let(:dummy_class) do
    Class.new do
      include ActiveModel::Validations
      attr_accessor :pivotaltracker_url
      validates_with PivotalTrackerUrlValidator
    end
  end

  subject { dummy_class.new }

  it 'should be valid for a valid pivotal project url' do
    subject.pivotaltracker_url = 'https://www.pivotaltracker.com/s/projects/982890'
    subject.valid?
    expect(subject.errors.full_messages).to eq([])
  end

  ['http://github.com/AgileVentures/WebsiteOne','<>hi'].each do |invalid_url|
    it "#{invalid_url.inspect} is an invalid url" do
      subject.pivotaltracker_url = invalid_url
      subject.valid?
      expect(subject.errors).to have_key(:pivotaltracker_url)
    end
  end
end
