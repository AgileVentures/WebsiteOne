# frozen_string_literal: true

describe ImageUrlValidator do
  let(:dummy_class) do
    Class.new do
      include ActiveModel::Validations
      attr_accessor :image_url

      validates_with ImageUrlValidator
    end
  end

  subject { dummy_class.new }

  it 'should be valid for a valid image url' do
    subject.image_url = 'https://www.facebook.com/filename.jpg'
    expect(subject).to be_valid
  end

  it 'should reject non-URLs' do
    subject.image_url = 'smile.txt'
    expect(subject).to be_invalid
  end

  it 'should reject an invalid file format' do
    subject.image_url = 'http://www.facebook.com'
    expect(subject).to be_invalid
  end

  ['http://github.com/AgileVentures/WebsiteOne', '<>hi'].each do |invalid_url|
    it "#{invalid_url.inspect} is an invalid url" do
      subject.image_url = invalid_url
      subject.valid?
      expect(subject.errors).to have_key(:image_url)
    end
  end
end
