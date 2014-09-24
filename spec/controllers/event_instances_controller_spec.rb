require 'spec_helper'

describe EventInstancesController do
  let(:params) { {id: '333', host_id: 'host', title: 'title'} }

  before do
    allow(controller).to receive(:allowed?).and_return(true)
    allow(SlackService).to receive(:post_hangout_notification)
    request.env['HTTP_ORIGIN'] = 'http://test.com'
  end

  describe '#index' do
    before do
      FactoryGirl.create_list(:event_instance, 3, updated: 1.minute.ago)
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
      allow_any_instance_of(EventInstance).to receive(:update_attributes).and_return('true')
    end

    it 'creates a hangout if there is no hangout associated with the event' do
      get :update, params
      hangout = EventInstance.find_by_uid('333')
      expect(hangout).to be_valid
    end

    it 'attempts to update a hangout if it exists' do
      FactoryGirl.create(:event_instance, uid: '333')
      expect_any_instance_of(EventInstance).to receive(:update_attributes)
      get :update, params
    end

    it 'returns a success response if update is successful' do
      get :update, params
      expect(response.status).to eq(200)
    end

    it 'calls the SlackService to post hangout notification on successful update' do
      expect(SlackService).to receive(:post_hangout_notification).with(an_instance_of(EventInstance))
      get :update, params.merge(notify: 'true')
    end

    it 'does not call the SlackService' do
      allow_any_instance_of(EventInstance).to receive(:update_attributes).and_return(false)
      expect(SlackService).not_to receive(:post_hangout_notification).with(an_instance_of(EventInstance))
      get :update, params.merge(notify: 'false')
    end

    it 'returns a failure response if update is unsuccessful' do
      allow_any_instance_of(EventInstance).to receive(:update_attributes).and_return(false)
      allow(EventInstance).to receive(:create).and_return(nil)
      get :update, params
      expect(response.status).to eq(500)
    end

    it 'redirects to event show page if the link was updated manually' do
      allow(controller).to receive(:local_request?).and_return(true)
      get :update, params.merge(event_id: '50')
      expect(response).to redirect_to(event_path(50))
    end

    context 'required parameters are missing' do
      it 'raises exception on missing title' do
        params[:title] = nil
        expect{ put :update, params }.to raise_error(ActionController::ParameterMissing)
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
