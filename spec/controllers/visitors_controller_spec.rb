require 'spec_helper'

describe VisitorsController do
    it 'renders index template' do
      get :index
      expect(response).to render_template('index')
    end

    it 'renders send successfully message' do
      post :send_contact_form
      expect(response).to redirect_to '/'
      expect(flash[:notice]).to eq('Your message has been sent successfully!')
    end

    it 'renders failure message' do
      Mailer.stub(contact_form: false)
      post :send_contact_form
      expect(response).to redirect_to '/'
      expect(flash[:alert]).to eq('Your message has not been sent!')
    end

    it 'calls mailer' do
      expect(Mailer).to receive(:contact_form)
      post :send_contact_form
    end

    it 'checks field Name' do
      post :send_contact_form, name: '', message: '123'
      expect(flash[:alert]).to eq('Please, fill in Name and Message field')
    end

    it 'checks field Message' do
      post :send_contact_form, name: '123', message: ''
      expect(flash[:alert]).to eq('Please, fill in Name and Message field')
    end
end
