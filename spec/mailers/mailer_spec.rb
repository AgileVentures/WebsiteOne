require 'spec_helper'

describe Mailer do
  describe '#contact_form' do
    let(:valid_params) { { name: 'Ivan', email: 'my@email.com', message: 'Love your site!' } }

    it 'validates email address'
    #TODO YA add email regex /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

    it 'fills in email message with details from contact form' do
      mail = Mailer.contact_form(valid_params)
      expect(mail.from).to include('my@email.com')
      expect(mail.to).to include('wso.av.test@gmail.com')
      expect(mail.subject).to include('WebsiteOne Contact Form')
      expect(mail.body.raw_source).to include('Love your site!')
    end
    it 'forms a confirmation email for contact_form' do
      mail = Mailer.contact_form_confirmation(valid_params)
      expect(mail.from).to include('site@websiteone.com')
      expect(mail.to).to include('my@email.com')
      expect(mail.subject).to include('WebsiteOne Contact Form')
      expect(mail.body.raw_source).to include('Thank you for your feedback')
    end
  end
end
