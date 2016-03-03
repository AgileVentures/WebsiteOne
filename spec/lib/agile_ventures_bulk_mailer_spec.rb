require 'spec_helper'

describe AgileVentures::BulkMailer do
  before(:each) do
    2.times { FactoryGirl.create(:user) }

    @opts = { subject: 'my subject',
              heading: 'my heading',
              content: 'my multiline\ntext block' }
  end

  it 'can be initialized' do
    bulk_mailer = AgileVentures::BulkMailer.new(@opts)
    expect(bulk_mailer).to_not be_nil
  end

  it 'will return num sent mails' do
    expect(AgileVentures::BulkMailer.new(@opts).run).to eq(2)
  end

  it 'responds to #num_sent' do
    expect(AgileVentures::BulkMailer.new(@opts)).to respond_to(:num_sent)
  end

  it 'responds to #used_addresses' do
    expect(AgileVentures::BulkMailer.new(@opts)).to respond_to(:used_addresses)
  end

  it 'returns email-addresses' do
    bulk_mailer = AgileVentures::BulkMailer.new(@opts)
    bulk_mailer.run
    expect(bulk_mailer.used_addresses.sort).to eq(User.all.map(&:email).sort)
  end

  it 'creates and applies instance vars' do
    bulk_mailer = AgileVentures::BulkMailer.new(@opts)
    expect(bulk_mailer.instance_variables).to include(:@heading &&
                                                   :@content &&
                                                   :@subject &&
                                                   :@batch_size
                                                   )
    [:@heading, :@subject].each do |word|
      expect(bulk_mailer.instance_variable_get(word)).to eq("my #{word.to_s.split('@')[-1]}")
    end
  end
  
  describe 'missing arguments' do
    it 'raises KeyError without :heading' do
      expect do
        AgileVentures::BulkMailer.new({content: 'foo'})
      end.to raise_error KeyError
    end
  
    it 'raises KeyError without :content' do
      expect do
        AgileVentures::BulkMailer.new({heading: 'foo'})
      end.to raise_error KeyError
    end
  end
  
end
