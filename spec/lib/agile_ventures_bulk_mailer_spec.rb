require 'spec_helper'

describe AgileVentures::BulkMailer do
  before do
    2.times do 
      FactoryGirl.create(:user, email: "#{rand(1000)}@example.com")
    end
    @opts = { subject: 'my subject',
              heading: 'my heading',
              content: 'my multiline\ntext block' }
  end

  it 'can be initialized' do
    bulk_mailer = AgileVentures::BulkMailer.new(@opts)
    bulk_mailer.should_not be_nil
  end

  it 'will return num sent mails' do
    AgileVentures::BulkMailer.new(@opts).run.should eq(2)
  end

  it 'responds to #num_sent' do
    AgileVentures::BulkMailer.new(@opts).should respond_to(:num_sent)
  end

  it 'responds to #used_addresses' do
    AgileVentures::BulkMailer.new(@opts).should respond_to(:used_addresses)
  end

  it 'returns email-addresses' do
    bulk_mailer = AgileVentures::BulkMailer.new(@opts)
    bulk_mailer.run
    bulk_mailer.used_addresses.sort.should eq(User.all.map(&:email).sort)
  end

  it 'creates and applies instance vars' do
    bulk_mailer = AgileVentures::BulkMailer.new(@opts)
    bulk_mailer.instance_variables.should include(:@heading &&
                                                   :@content &&
                                                   :@subject &&
                                                   :@batch_size
                                                   )
    [:@heading, :@subject].each do |word|
      bulk_mailer.instance_variable_get(word).should 
      eq("my #{word.to_s.split('@')[-1]}")
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
