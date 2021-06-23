# frozen_string_literal: true

describe Mailer do
  describe 'send_premium_payment_complete_message' do
    let(:plan) { instance_double(Plan, name: 'Premium', free_trial_length_days: 7, free_trial?: true, category: nil) }
    it 'is expected to send payment complete message' do
      mail = Mailer.send_premium_payment_complete(plan, 'candice@clemens.com')
      expect(mail.from).to include('info@agileventures.org')
      expect(mail.reply_to).to include('info@agileventures.org')
      expect(mail.to).to include('candice@clemens.com')
      expect(mail.subject).to include('Welcome to AgileVentures Premium')
      expect(mail.body.raw_source).to include('Thanks for signing up for AgileVentures Premium!')
      expect(mail).to have_default_cc_addresses
    end
  end

  describe '#send_welcome_message' do
    before(:each) do
      @user = User.new first_name: 'Email',
                       last_name: 'Sender',
                       email: 'candice@clemens.com',
                       password: '1234567890'
    end

    it 'is expected to send welcome message' do
      mail = Mailer.send_welcome_message(@user)
      expect(mail.from).to include('info@agileventures.org')
      expect(mail.reply_to).to include('info@agileventures.org')
      expect(mail.to).to include('candice@clemens.com')
      expect(mail.subject).to include('Welcome to AgileVentures.org')
      expect(mail.body.raw_source).to include('Welcome!')
      expect(mail).to have_default_cc_addresses
    end
  end

  describe '#hire_me_contact_form' do
    let(:valid_params) { { name: 'Thomas', email: 'thomas@email.com', message: 'Want to hire you!' } }
    before(:each) do
      @user = User.new first_name: 'Marcelo',
                       last_name: 'Mr G',
                       email: 'marcelo@whatever.com',
                       password: '1234567890'
    end
    it 'is expected to send hire_me message' do
      mail = Mailer.hire_me_form(@user, valid_params)
      expect(mail.from).to include('thomas@email.com')
      expect(mail.reply_to).to include('thomas@email.com')
      expect(mail.to).to include('marcelo@whatever.com')
      expect(mail.subject).to include(['message from', valid_params[:name]].join(' '))
      expect(mail.body.raw_source).to include(valid_params[:message])
      expect(mail).to have_default_cc_addresses
    end
  end
end
