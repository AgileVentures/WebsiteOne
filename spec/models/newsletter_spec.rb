require 'spec_helper'

describe Newsletter do
  it 'has a valid factory' do
    FactoryGirl.build(:newsletter).should be_valid
  end

  describe "is invalid" do
    it 'when subejct is empty' do
      FactoryGirl.build(:newsletter, subject: nil).should_not be_valid
    end

    it 'when title is emtpy' do
      FactoryGirl.build(:newsletter, title: nil).should_not be_valid
    end

    it 'when body is empty' do
      FactoryGirl.build(:newsletter, body: nil).should_not be_valid
    end
  end

  describe "class variables" do
    before do
     stub_const("Newsletter::CHUNK_SIZE",Settings.newsletter.chunk_size)
     stub_const("Newsletter::SEND_AS",Settings.newsletter.send_as)
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
      stub_const("Newsletter::SEND_AS",:instant)
      @newsletter.do_send=true
    end

    it 'after do_send is set to true' do
      expect{ @newsletter.save! }.to change{ ActionMailer::Base.deliveries.count }.by(2)
    end

    it 'updates sent_at with Time' do
      @newsletter.save
      expect(@newsletter.sent_at).to be_a_kind_of(Time)
    end

    it 'updates was_sent to true' do
      @newsletter.save
      expect(@newsletter.was_sent).to eq(true)
    end
  end

  describe 'does not instantely send in scheduler_job mode' do
    before :each do
      @newsletter = FactoryGirl.build(:newsletter)
      @receiver_users = FactoryGirl.create_list(:user, 5, receive_mailings: true)
      @non_receiver_users = FactoryGirl.create_list(:user, 5, receive_mailings: false)
      @newsletter.do_send = true
      @newsletter.was_sent=false;
      stub_const("Newsletter::CHUNK_SIZE",100)
      stub_const("Newsletter::SEND_AS",:scheduler_job)
    end

    it 'awaits scheduler' do
      expect(@newsletter.do_send).to eq(true)
      expect(@newsletter.was_sent).to eq(false)
      expect(@newsletter.last_user_id).to eq(0)
      expect{ @newsletter.save!}.to change{ ActionMailer::Base.deliveries.count}.by(0)
    end

    it 'after do_send is set to true in this schedulized mode' do
      stub_const("Newsletter::SEND_AS",:instant)
      expect{ @newsletter.save! }.to change{ ActionMailer::Base.deliveries.count }.by(5)
    end

    it 'updates sent_at with Time in this schedulised mode' do
      stub_const("Newsletter::SEND_AS",:instant)
      @newsletter.save!
      expect(@newsletter.sent_at).to be_a_kind_of(Time)
    end

    it 'updates was_sent to true in this schedulised mode' do
      stub_const("Newsletter::SEND_AS",:instant)
      @newsletter.save!
      expect(@newsletter.was_sent).to eq(true)
    end
    it 'update the last_user_id in this mode' do
      stub_const("Newsletter::SEND_AS",:instant)
      expect{@newsletter.save!}.to change{@newsletter.last_user_id}.by(@receiver_users[4].id)
    end
  end
end
