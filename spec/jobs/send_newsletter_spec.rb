require 'spec_helper'

describe SendNewsletter do

  describe 'processes' do
    before :each do
      Newsletter.redefine_without_warning('CHUNK_SIZE', 5 ) # by default at 180 - but too much overhead in specs
      # make sure it takes 2 runs - a.k.a more user than CHUNK_SIZE
      FactoryGirl.create_list(:user, Newsletter::CHUNK_SIZE + Newsletter::CHUNK_SIZE/2)
      @newsletter = FactoryGirl.create(:newsletter, do_send: true)
    end

    after :all do
      Newsletter.redefine_without_warning('CHUNK_SIZE', 180 ) # reset to default
    end

    it 'specified chunk-size' do
      expect { SendNewsletter.run }.to change { ActionMailer::Base.deliveries.count }.by( Newsletter::CHUNK_SIZE )
      @newsletter.reload
    end

    it 'persists last processed user_id' do
      SendNewsletter.run
      @newsletter.reload
      expect(@newsletter.last_user_id).to be > 0
    end

    it 'was_sent is false until all recipients processed' do
      expect(SendNewsletter.run).to_not be_nil
      @newsletter.reload
      expect(@newsletter.was_sent).to be_falsey
    end

    it 'was_sent is true if all recipients processed' do
      2.times { SendNewsletter.run }
      @newsletter.reload
      expect(@newsletter.was_sent).to be_truthy
    end

    it 'sends newsletter to adequate users per run' do
      # empty mail-queue
      ActionMailer::Base.deliveries = []

      first_chunk = User.mail_receiver.order('id ASC').limit(Newsletter::CHUNK_SIZE)
      second_chunk = User.mail_receiver.order('id ASC').where('id > ?', first_chunk.last.id)
      # first run
      SendNewsletter.run
      @newsletter.reload

      expect(@newsletter.last_user_id).to eq(first_chunk.last.id)
      expect(ActionMailer::Base.deliveries.map(&:to).flatten).to eq(first_chunk.map(&:email))

      # empty mail-queue
      ActionMailer::Base.deliveries = []
      #second run
      SendNewsletter.run
      @newsletter.reload

      expect(@newsletter.last_user_id).to eq(second_chunk.last.id)
      expect(ActionMailer::Base.deliveries.map(&:to).flatten).to eq(second_chunk.map(&:email))
    end
  end

  describe 'no unsent newsletter' do
    it 'returns nil' do
      expect(SendNewsletter.run).to be_nil
    end
  end
end
