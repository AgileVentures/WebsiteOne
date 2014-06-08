require 'spec_helper'

describe VisitorsController do
  let(:valid_params){ {name: 'Ivan', email: 'my@email.com', message: 'Love your site!'} }
  it 'renders index template' do
    get :index
    expect(response).to render_template('index')
  end

  it 'assigns event to next_occurrence' do
    event = double(Event)
    Event.should_receive(:next_event_occurrence).and_return(event)
    get :index
    expect(assigns(:event)).to eq event
  end

  describe '#send_contact_form' do

    before(:each) do
      @previous_page = '/'
      @request.env['HTTP_REFERER'] = @previous_page
      Mailer.stub_chain(:contact_form, :deliver).and_return(true)

      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries = []
    end

    it 'renders successful message' do
      post :send_contact_form, valid_params
      expect(response).to redirect_to @previous_page
      expect(flash[:notice]).to eq('Your message has been sent successfully!')
    end

    it 'renders failure message' do
      Mailer.stub_chain(:contact_form, :deliver).and_return(false)
      post :send_contact_form, valid_params
      expect(response).to redirect_to @previous_page
      expect(flash[:alert]).to eq('Your message has not been sent!')
    end

    it 'checks field Name' do
      post :send_contact_form, name: '', message: '123'
      expect(flash[:alert]).to eq('Please, fill in Name and Message field')
    end

    it 'checks field Message' do
      post :send_contact_form, name: '123', message: ''
      expect(flash[:alert]).to eq('Please, fill in Name and Message field')
    end

    it 'calls mailer' do
      expect(Mailer).to receive(:contact_form) do |arg|
        expect(arg).to include(valid_params)
        double(ActionMailer::Base).as_null_object
      end
      post :send_contact_form, valid_params
    end

    it 'sends the email to site admin' do
      allow(Mailer).to receive(:contact_form).and_call_original

      post :send_contact_form, valid_params
      expect(ActionMailer::Base.deliveries[0].body).to include('Love your site!')
    end

    it 'sends confirmation email to user if email is valid' do
      allow(Mailer).to receive(:contact_form).and_call_original

      post :send_contact_form, valid_params
      expect(ActionMailer::Base.deliveries[1].body).to include('Thank you for your feedback')
    end
  end
end
