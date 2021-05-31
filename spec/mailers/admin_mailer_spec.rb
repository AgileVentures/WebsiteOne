# frozen_string_literal: true

describe AdminMailer, type: :mailer do
  context 'slack invite errors' do
    context 'ruby error' do
      subject(:mailer) do
        AdminMailer.failed_to_invite_user_to_slack('tansaku@gmail.com', StandardError.new('Boom!'), nil)
      end
      it 'sends a mail' do
        expect { mailer.deliver_now }.to change { ActionMailer::Base.deliveries.length }.by(1)
      end
      it 'contains error message in body' do
        expect(mailer.body).to include 'Boom!'
      end
    end
    context 'slack api error' do
      subject(:mailer) { AdminMailer.failed_to_invite_user_to_slack('tansaku@gmail.com', nil, 'already_invited') }
      it 'sends a mail' do
        expect { mailer.deliver_now }.to change { ActionMailer::Base.deliveries.length }.by(1)
      end
      it 'contains error message in body' do
        expect(mailer.body).to include 'already_invited'
      end
    end
  end
end
