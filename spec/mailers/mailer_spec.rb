require "spec_helper"

describe Mailer do
  describe '#contact_form' do
    let(:valid_params) { { name: 'Ivan', email: 'my@email.com', message: 'Love your site!' } }
    it 'fills in email message with details from contact form' do
      mail = Mailer.contact_form(valid_params)
      expect(mail.from).to include('my@email.com')
      expect(mail.to).to include('yaro@rusvil.ru')
      expect(mail.subject).to include('WebsiteOne Contact Form')
      expect(mail.body.raw_source).to include('Love your site!')
    end
  end
end
