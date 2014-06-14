require 'spec_helper'

describe BulkMailer do
  before do
    2.times do |i|
      FactoryGirl.create(:user, email: "#{i}@example.com")
    end
    @opts = { subject: 'my subject',
              heading: 'my heading',
              content: 'my multiline\ntext block' }
    BulkMailer.any_instance.stub(:puts) # Added to prevent pollution of tests
  end
  after do
    User.delete_all
  end

  it 'can be initialized' do
    bulk_mailer = BulkMailer.new(@opts)
    bulk_mailer.should_not be_nil
  end

  it 'will return num sent mails' do
    BulkMailer.new(@opts).run.should eq(2)
  end

  it 'responds to #num_sent' do
    BulkMailer.new(@opts).should respond_to(:num_sent)
  end

  it 'responds to #used_addresses' do
    BulkMailer.new(@opts).should respond_to(:used_addresses)
  end

  it 'returns email-addresses' do
    bulk_mailer = BulkMailer.new(@opts)
    bulk_mailer.run
    bulk_mailer.used_addresses.sort.should eq(User.all.map(&:email).sort)
  end

  it 'creates and applies instance vars' do
    bulk_mailer = BulkMailer.new(@opts)
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

  it 'should send an exactly two emails' do
    ActionMailer::Base.deliveries.clear
    BulkMailer.new(@opts).run

    ActionMailer::Base.deliveries.size.should eq 2
    emails = ActionMailer::Base.deliveries
    emails.each_with_index do |email, i|
      expect(email.subject).to include 'my subject'
      expect(email.to[0]).to eq "#{i}@example.com"
    end
  end
  
  describe 'missing arguments' do
    it 'raises KeyError without :heading' do
      expect do
        BulkMailer.new({content: 'foo'})
      end.to raise_error KeyError
    end
  
    it 'raises KeyError without :content' do
      expect do
        BulkMailer.new({heading: 'foo'})
      end.to raise_error KeyError
    end
  end


  describe '::help' do
    it 'show some advice how to initiate BulkMailer' do
      help = "BulkMailer.new(heading: 'my_heading',
                            subject: 'my subject',
                            content: 'multiline text')\n
              opts[:content]::  the content or body of the mailing\n
              opts[:heading]::  a specific headline for the mailing\n
              opts[:batch_size]:: the batch-size in which users are pulled off db\n
              opts[:subject]::    the subject header of the mailing"
      BulkMailer.should_receive(:puts).with(help)
      BulkMailer.help
    end
  end

  describe '#waiting_seconds' do
    it 'should sleep for exactly 10 seconds and print a progress bar' do
      Rails.stub(:env).and_return('development')
      mailer = BulkMailer.new(@opts)
      mailer.should_receive(:sleep).with(1).exactly(10).times
      mailer.should_receive(:print).with('. ').exactly(10).times
      mailer.send(:waiting_seconds)
    end
  end
end
