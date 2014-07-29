require 'spec_helper'

describe HangoutsController do

  before :each do
    controller.stub(allowed?: true)
    request.env['HTTP_ORIGIN'] = 'http://test.com'
    SlackService.stub(:post_hangout_notification)
  end

  describe '#update' do
    it 'creates a hangout if there is no hangout assosciated with the event' do
      hangout_id = '333'
      get :update, {id: hangout_id}

      hangout = Hangout.find_by_uid(hangout_id)
      expect(hangout).to be_valid
    end

    it 'updates a hangout if it is present' do
      expect_any_instance_of(Hangout).to receive(:update_hangout_data)
      get :update, {id: '333', hangout_data: 'data'}
    end

    it 'returns a success response if update is successful' do
      Hangout.any_instance.stub(update_hangout_data: true)

      get :update, {id: '333'}
      expect(response.status).to eq(200)
    end

    it 'calls the SlackService to post hangout notification on successful update' do
      Hangout.any_instance.stub(update_hangout_data: true)
      expect(SlackService).to receive(:post_hangout_notification).with(an_instance_of(Hangout))

      get :update, {id: '333', notify: 'true'}
    end

    it 'does not call the SlackService' do
      allow_any_instance_of(Hangout).to receive(:update_hangout_data).and_return(true)
      expect(SlackService).not_to receive(:post_hangout_notification).with(an_instance_of(Hangout))

      get :update, {id: '333', notify: 'false'}
    end

    it 'returns a failure response if update is unsuccessful' do
      Hangout.any_instance.stub(update: false)

      get :update, {id: '333'}
      expect(response.status).to eq(500)
    end

    it 'redirects to event show page if the link was updated manually' do
      allow(controller).to receive(:local_request?).and_return(true)
      allow_any_instance_of(Hangout).to receive(:update_hangout_data).and_return(true)

      get :update, {id: '333', event_id: 50}
      expect(response).to redirect_to(event_path(50))
    end
  end

  describe 'CORS handling' do
    it 'drops request if the origin is not allowed' do
      controller.stub(allowed?: false)
      get :update, {id: '333'}
      expect(response.status).to eq(400)
    end

    it 'sets CORS headers' do
      Hangout.any_instance.stub(update_hangout_data: true)
      headers = { 'Access-Control-Allow-Origin' => 'http://test.com',
                  'Access-Control-Allow-Methods' => 'PUT' }

      get :update, {id: '333'}
      expect(response.headers).to include(headers)
    end

    it 'responses OK on preflight check' do
      get :update, {id: '333'}
      expect(response.status).to eq(200)
    end
  end

end
