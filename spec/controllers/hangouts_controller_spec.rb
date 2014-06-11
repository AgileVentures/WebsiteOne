require 'spec_helper'

describe HangoutsController do

  describe '#update' do
    it 'creates a hangout if there is no hangout assosciated with the event' do
      event_id = '333'

      get :update, {id: event_id}

      hangout = Hangout.find_by_event_id(event_id)
      expect(hangout).to be_valid
    end

    it 'updates a hangout if it is present' do
      expect_any_instance_of(Hangout).to receive(:update_hangout_data)
      get :update, {id: '333', hangout_data: 'data'}
    end

    it 'sets CORS headers' do
      Hangout.any_instance.stub(update_hangout_data: true)
      headers = { 'Access-Control-Allow-Origin' => '*',
                  'Access-Control-Request-Method' => 'GET' }

      get :update, {id: '333'}
      expect(response.headers).to include(headers)
    end

    it 'returns a success response if update is successful' do
      Hangout.any_instance.stub(update_hangout_data: true)

      get :update, {id: '333'}
      expect(response.body).to have_text('Success')
    end

    it 'returns a failure response if update is unsuccessful' do
      Hangout.any_instance.stub(update: false)

      get :update, {id: '333'}
      expect(response.body).to have_text('Failure')
    end
  end

end
