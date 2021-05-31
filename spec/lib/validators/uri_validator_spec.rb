# frozen_string_literal: true

# from https://gist.github.com/timocratic/5113293

describe UriValidator do
  let(:dummy_class) do
    Class.new do
      include ActiveModel::Validations
      attr_accessor :url

      validates :url, uri: true
    end
  end

  subject { dummy_class.new }

  it 'should be valid for a valid http url' do
    subject.url = 'http://www.google.com'
    subject.valid?
    expect(subject.errors.full_messages).to eq([])
  end

  ['http:/www.google.com', '<>hi'].each do |invalid_url|
    it "#{invalid_url.inspect} is an invalid url" do
      subject.url = invalid_url
      subject.valid?
      expect(subject.errors).to have_key(:url)
    end
  end

  it 'should be invalid for an unaccepted protocol' do
    subject.url = 'smtp://www.google.com'
    subject.valid?
    expect(subject.errors[:url].to_sentence).to eq 'must begin with http or https'
  end
end
