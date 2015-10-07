require 'spec_helper'

describe EventInstancesController do
  let(:params) { {id: '333', host_id: 'host', title: 'title'} }

  before do
    allow(controller).to receive(:allowed?).and_return(true)
    allow(SlackService).to receive(:post_hangout_notification)
    allow(TwitterService).to receive(:tweet_hangout_notification)
    allow(TwitterService).to receive(:tweet_yt_link)
    request.env['HTTP_ORIGIN'] = 'http://test.com'
  end

  describe '#index' do
    before do
      FactoryGirl.create_list(:event_instance, 3)
      FactoryGirl.create_list(:event_instance, 3, updated: 1.hour.ago)
    end

    context 'show all hangouts/event-instances' do
      it 'assigns all hangouts' do
        get :index
        expect(assigns(:event_instances).count).to eq(6)
      end
    end

    context 'show only live hangouts/event-instances' do
      it 'assigns live hangouts' do
        get :index, {live: 'true'}
        expect(assigns(:event_instances).count).to eq(3)
      end
    end
  end

  describe '#update' do
    before do
      allow_any_instance_of(EventInstance).to receive(:update).and_return('true')
    end

    it 'creates a hangout if there is no hangout assosciated with the event' do
      get :update, params
      hangout = EventInstance.find_by_uid('333')
      expect(hangout).to be_valid
    end

    it 'updates a hangout if it is present' do
      expect_any_instance_of(EventInstance).to receive(:update)
      get :update, params
    end

    it 'returns a success response if update is successful' do
      get :update, params
      expect(response.status).to eq(200)
    end

    context 'slack notification' do
      it 'calls the SlackService to post hangout notification on successful update' do
        expect(SlackService).to receive(:post_hangout_notification).with(an_instance_of(EventInstance))
        get :update, params.merge(notify: 'true')
      end

      it 'does not call the SlackService if not update' do
        allow_any_instance_of(EventInstance).to receive(:update).and_return(false)
        expect(SlackService).not_to receive(:post_hangout_notification).with(an_instance_of(EventInstance))
        get :update, params.merge(notify: 'true')
      end

      it 'does not call the SlackService if not notify' do
        expect(SlackService).not_to receive(:post_hangout_notification).with(an_instance_of(EventInstance))
        get :update, params.merge(notify: 'false')
      end
    end

    context 'twitter notification' do
      it 'calls the TwitterService to tweet yt_link if yt_video_id is changed' do
        expect(TwitterService).to receive(:tweet_yt_link).with(an_instance_of(EventInstance))
        expect_any_instance_of(EventInstance).to receive(:yt_video_id_changed?).and_return(true)
        get :update, params.merge(yt_video_id: 'new_video_id')
      end

      it 'does not calls the TwitterService to tweet yt_link if yt_video_id is not changed' do
        expect(TwitterService).not_to receive(:tweet_yt_link).with(an_instance_of(EventInstance))
        expect_any_instance_of(EventInstance).to receive(:yt_video_id_changed?).and_return(false)
        get :update, params
      end

      it 'calls the TwitterService to tweet notification if event has started and hangout url changed' do
        expect(TwitterService).to receive(:tweet_hangout_notification).with(an_instance_of(EventInstance))
        expect_any_instance_of(EventInstance).to receive(:hangout_url_changed?).and_return(true)
        expect_any_instance_of(EventInstance).to receive(:started?).and_return(true)
        get :update, params.merge(hangout_url: 'new_hangout_url')
      end

      it 'does not call the TwitterService to tweet notification if event has not started' do
        expect(TwitterService).not_to receive(:tweet_hangout_notification).with(an_instance_of(EventInstance))
        expect_any_instance_of(EventInstance).to receive(:started?).and_return(false)
        get :update, params.merge(hangout_url: 'new_hangout_url')
      end

      it 'does not call the TwitterService to tweet notification if event hangout url has not changed' do
        expect(TwitterService).not_to receive(:tweet_hangout_notification).with(an_instance_of(EventInstance))
        expect_any_instance_of(EventInstance).to receive(:hangout_url_changed?).and_return(false)
        expect_any_instance_of(EventInstance).to receive(:started?).and_return(true)
        get :update, params.merge(hangout_url: 'new_hangout_url')
      end
    end

    it 'returns a failure response if update is unsuccessful' do
      allow_any_instance_of(EventInstance).to receive(:update).and_return(false)
      get :update, params
      expect(response.status).to eq(500)
    end

    it 'redirects to event show page if the link was updated manually' do
      allow(controller).to receive(:local_request?).and_return(true)
      get :update, params.merge(event_id: '50')
      expect(response).to redirect_to(event_path(50))
    end

    it 'update EventInstance with permited params' do
      upd_params = {
        "title"=>"title", "project_id"=>"project_id", "event_id"=>"event_id",
        "category"=>"category", "user_id"=>"host", "participants"=>"one, two",
        "hangout_url"=>"test_url", "yt_video_id"=>"video", "hoa_status"=>"started"
      }
      expect_any_instance_of(EventInstance).to receive(:update).with(upd_params)
      get :update, params.merge(upd_params)
    end

    context 'required parametes are missing' do
      it 'raises exception on missing host_id' do
        params[:host_id] = nil
        expect{ get :update, params }.to raise_error(ActionController::ParameterMissing)
      end

      it 'raises exception on missing title' do
        params[:title] = nil
        expect{ get :update, params }.to raise_error(ActionController::ParameterMissing)
      end

    end
  end

  describe 'CORS handling' do
    it 'drops request if the origin is not allowed' do
      allow(controller).to receive(:allowed?).and_return(false)
      get :update, params
      expect(response.status).to eq(400)
    end

    it 'sets CORS headers' do
      headers = { 'Access-Control-Allow-Origin' => 'http://test.com',
                  'Access-Control-Allow-Methods' => 'PUT' }

      get :update, params
      expect(response.headers).to include(headers)
    end

    it 'responses OK on preflight check' do
      get :update, params
      expect(response.status).to eq(200)
    end
  end

end
