require 'spec_helper'

describe Newsletter do
  it 'has a valid factory' do
    expect(FactoryGirl.build(:newsletter)).to be_valid
  end

  describe "is invalid" do
    it 'when subejct is empty' do
      expect(FactoryGirl.build(:newsletter, subject: nil)).to_not be_valid
    end

    it 'when title is emtpy' do
      expect(FactoryGirl.build(:newsletter, title: nil)).to_not be_valid
    end

    it 'when body is empty' do
      expect(FactoryGirl.build(:newsletter, body: nil)).to_not be_valid
    end
  end

  describe "class variables" do
    before do
      Newsletter.redefine_without_warning('CHUNK_SIZE', Settings.newsletter.chunk_size)
      Newsletter.redefine_without_warning('SEND_AS', Settings.newsletter.send_as)
    end

    it 'configures as scheduler_job' do
      expect(Newsletter::SEND_AS).to eq(:scheduler_job)
    end

    it 'configures 180 recipients per run' do
      expect(Newsletter::CHUNK_SIZE).to eq(180)
    end
  end

  describe 'sends mailings in instant mode' do
    before :each do 
      receiver_users = FactoryGirl.create_list(:user, 2, receive_mailings: true)
      non_receiver_users = FactoryGirl.create_list(:user, 2, receive_mailings: false)
      @newsletter = FactoryGirl.create(:newsletter)
      Newsletter.redefine_without_warning('SEND_AS', :instant)
    end

    after :all do
      Newsletter.redefine_without_warning('CHUNK_SIZE', 180)
      Newsletter.redefine_without_warning('SEND_AS', :scheduler_job)
    end

    it 'after do_send is set to true' do
      @newsletter.do_send = true
      expect{ @newsletter.save! }.to change{ ActionMailer::Base.deliveries.count }.by(2)
    end

    it 'updates sent_at with Time' do
      @newsletter.do_send = true
      @newsletter.save
      @newsletter.reload 
      expect(@newsletter.sent_at).to be_a(Time)
    end

    it 'updates was_sent to true' do
      @newsletter.do_send = true
      @newsletter.save
      @newsletter.reload
      expect(@newsletter.was_sent).to eq(true)
    end
  end

  describe 'does not instantely send in scheduler_job mode' do
    before :each do
      @newsletter = FactoryGirl.build(:newsletter)
    end

    it 'awaits scheduler' do
      @newsletter.do_send = true
      expect{ @newsletter.save!}.to change{ ActionMailer::Base.deliveries.count}.by(0)
    end
  end
end
