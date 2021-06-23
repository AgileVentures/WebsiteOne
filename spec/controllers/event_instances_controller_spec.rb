# frozen_string_literal: true

RSpec.describe EventInstancesController do
  let(:params) { { id: '333', host_id: 'host', title: 'title' } }

  before do
    allow(HangoutNotificationService).to receive(:with)
    allow(YoutubeNotificationService).to receive(:with)
    request.env['HTTP_ORIGIN'] = 'http://test.com'
  end

  describe '#index' do
    before do
      create_list(:event_instance, 3)
      create_list(:event_instance, 3, updated: 1.hour.ago)
    end

    context 'show all hangouts/event-instances' do
      it 'assigns all hangouts' do
        get :index
        expect(assigns(:event_instances).count).to eq(6)
      end
    end

    context 'show only live hangouts/event-instances' do
      it 'assigns live hangouts' do
        get :index, params: { live: 'true' }
        expect(assigns(:event_instances).count).to eq(3)
      end
    end
  end

  describe '#update' do
    before do
      allow_any_instance_of(EventInstance).to receive(:update).and_return('true')
      allow(controller).to receive(:authenticate_user!).and_return(true)
    end

    it 'requires user to be logged in' do
      expect(controller).to receive(:authenticate_user!)
      get :update, params: params
    end

    it 'creates a hangout if there is no hangout assosciated with the event' do
      get :update, params: params
      hangout = EventInstance.find_by_uid('333')
      expect(hangout).to be_valid
    end

    it 'updates a hangout if it is present' do
      expect_any_instance_of(EventInstance).to receive(:update)
      get :update, params: params
    end

    it 'returns a success response if update is successful' do
      get :update, params: params
      expect(response.status).to eq(200)
    end

    context 'slack notification' do
      it 'calls the SlackService to post hangout notification on successful update' do
        expect(HangoutNotificationService).to receive(:with).with(an_instance_of(EventInstance))
        expect_any_instance_of(EventInstance).to receive(:hangout_url?).at_least(:once).and_return(true)
        get :update, params: params.merge(notify: 'true', hangout_url: 'test_url')
      end

      it 'does not call the SlackService if not update' do
        allow_any_instance_of(EventInstance).to receive(:update).and_return(false)
        expect(HangoutNotificationService).not_to receive(:with).with(an_instance_of(EventInstance))
        get :update, params: params.merge(notify: 'true')
      end

      it 'does not call the SlackService if not notify' do
        expect(HangoutNotificationService).not_to receive(:with).with(an_instance_of(EventInstance))
        get :update, params: params.merge(notify: 'false')
      end

      it 'calls the SlackService to post yt_link on successful update' do
        expect(YoutubeNotificationService).to receive(:with).with(an_instance_of(EventInstance))
        expect_any_instance_of(EventInstance).to receive(:yt_video_id?).at_least(:once).and_return(true)
        get :update, params: params.merge(notify_yt: 'true', yt_video_id: 'test')
      end

      it 'does not call the SlackService to post yt_link if not update' do
        allow_any_instance_of(EventInstance).to receive(:update).and_return(false)
        expect(YoutubeNotificationService).not_to receive(:with).with(an_instance_of(EventInstance))
        get :update, params: params.merge(notify: 'true')
      end

      it 'does not calls the SlackService to post yt_link if not notify' do
        expect(YoutubeNotificationService).not_to receive(:with).with(an_instance_of(EventInstance))
        get :update, params: params.merge(notify: 'false')
      end
    end

    it 'returns a failure response if update is unsuccessful' do
      allow_any_instance_of(EventInstance).to receive(:update).and_return(false)
      get :update, params: params
      expect(response.status).to eq(500)
    end

    it 'redirects to event show page if the link was updated manually' do
      allow(controller).to receive(:local_request?).and_return(true)
      get :update, params: params.merge(event_id: '50')
      expect(response).to redirect_to(event_path(50))
    end

    it 'update EventInstance with permitted params' do
      allow(Time).to receive(:now).and_return DateTime.parse('2016-06-23 13:57:37.073318243')
      upd_params = {
        'title' => 'title',
        'project_id' => 'project_id',
        'event_id' => 'event_id',
        'category' => 'category',
        'user_id' => 'host',
        'hangout_participants_snapshots_attributes' => [{ 'participants' => 'one, two' }],
        'participants' => 'one, two',
        'hangout_url' => 'test_url',
        'yt_video_id' => 'video',
        'hoa_status' => 'started',
        'url_set_directly' => nil,
        'updated_at' => Time.now,
        'youtube_tweet_sent' => nil
      }
      allow_any_instance_of(EventInstance).to receive(:update).with(upd_params)
      get :update, params: params.merge(upd_params)
    end

    context 'required parameters are missing' do
      it 'raises exception on missing host_id' do
        params[:host_id] = nil
        expect { get :update, params: params }.to raise_error(ActionController::ParameterMissing)
      end

      it 'raises exception on missing title' do
        params[:title] = nil
        expect { get :update, params: params }.to raise_error(ActionController::ParameterMissing)
      end
    end
  end
end
