require 'spec_helper'

describe HoServiceController do

  describe '#update' do
    it 'creates a video if there is no video assosciated with the event' do
      event_id = '333'

      get :update, {id: event_id}

      video = Video.find_by_video_id(event_id)
      expect(video).to be_true
    end

    it 'updates a video if it is present' do
      event_id = '333'
      Video.create(video_id: event_id)

      get :update, {id: event_id, :hangoutUrl => 'http://hangout.test' }

      video = Video.find_by_video_id(event_id)
      expect(video.hangout_url).to eq('http://hangout.test')
    end

    it 'sets CORS headers' do
      headers = { 'Access-Control-Allow-Origin' => '*',
                  'Access-Control-Request-Method' => 'GET' }
      get :update, {id: '333'}
      expect(response.headers).to include(headers)
    end

    it 'returns a success response if update is successful' do
      event_id = '333'
      get :update, {id: event_id}
      expect(response.body).to have_text('Success')
    end

    it 'returns a failure response if update is unsuccessful' do
      event_id = '333'
      Video.any_instance.stub(update: false)

      get :update, {id: event_id}

      expect(response.body).to have_text('Failure')
    end
  end

end
