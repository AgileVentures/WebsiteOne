require 'spec_helper'

describe VisitorsController do
  let(:valid_params){ {name: 'Ivan', email: 'my@email.com', message: 'Love your site!'} }
  it 'renders index template' do
    get :index
    expect(response).to render_template('index')
  end

  describe '#send_contact_form' do

    before(:each) do
      Mailer.stub(contact_form: true)

      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries = []
    end

    it 'renders send successfully message' do
      post :send_contact_form, valid_params
      expect(response).to redirect_to '/'
      expect(flash[:notice]).to eq('Your message has been sent successfully!')
    end

    it 'renders failure message' do
      Mailer.stub(contact_form: false)
      post :send_contact_form, valid_params
      expect(response).to redirect_to '/'
      expect(flash[:alert]).to eq('Your message has not been sent!')
    end

    it 'calls mailer' do
      expect(Mailer).to receive(:contact_form) do |arg|
        expect(arg).to include(valid_params)
      end
      post :send_contact_form, valid_params
    end

    it 'checks field Name' do
      post :send_contact_form, name: '', message: '123'
      expect(flash[:alert]).to eq('Please, fill in Name and Message field')
    end

    it 'checks field Message' do
      post :send_contact_form, name: '123', message: ''
      expect(flash[:alert]).to eq('Please, fill in Name and Message field')
    end

    it 'validates email address'
    #TODO YA add email regex /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

    it 'sends the email' do
      allow(Mailer).to receive(:contact_form).and_call_original

      post :send_contact_form, valid_params
      expect(ActionMailer::Base.deliveries.first.body).to include('Love your site!')
    end
  end
end
