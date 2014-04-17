require 'spec_helper'

describe EventsController do
  let(:event) { @event }
  let(:valid_session) { {} }

  before :each do
    @event = FactoryGirl.create(:event)
    @events = @event.current_occurences
  end

  describe 'GET index' do
    it 'should render "index"' do
      get :index
      assigns(:events).should eq(@events)
      response.should render_template :index
    end
  end

  describe 'GET show' do
    before(:each) do
      get :show, {:id => event.to_param}, valid_session
    end

    it 'assigns the requested event as @event' do
      assigns(:event).should eq(event)
    end

    it 'renders the show template' do
      expect(response).to render_template 'show'
    end
  end

  describe 'GET new' do
    before(:each) do
      @controller.stub(:authenticate_user!).and_return(true)
      get :new, valid_session
    end

    it 'assigns a new event as @event' do
      assigns(:event).should be_a_new(Event)
    end

    it 'renders the new template' do
      expect(response).to render_template 'new'
    end
  end

  describe 'POST create' do
    before :each do
      @controller.stub(:authenticate_user!).and_return(true)
    end

    context 'with valid attributes' do
      it 'saves the new event in the database' do
        expect {
          post :create, event: valid_attributes_for(:event)
        }.to change(Event, :count).by(1)
      end

      it 'redirects to events#show' do
        post :create, event: valid_attributes_for(:event)
        expect(response).to redirect_to event_path(controller.instance_variable_get('@event'))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new subject in the database' do
        #Event.any_instance.stub(:save).and_return(false)
        expect {
          post :create, event: invalid_attributes_for(:event)
        }.to_not change(Event, :count)
        assigns(:event).should be_a_new(Event)
        assigns(:event).should_not be_persisted
      end

      it 're-renders the events#new template' do
        Event.any_instance.stub(:save).and_return(false)
        post :create, event: invalid_attributes_for(:event)
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET edit' do
    before :each do
      @event = create(:event)
      @controller.stub(:authenticate_user!).and_return(true)
    end

    it 'assigns the requested event to @event' do
      get :edit, id: @event
      expect(assigns(:event)).to eq @event
    end

    it 'renders the events#edit template' do
      get :edit, id: @event
      expect(response).to render_template :edit
    end
  end

  describe 'POST update' do
    let(:valid_attributes) { { id: @event, event: valid_attributes_for(:event) } }

    before(:each) do
      controller.stub(:authenticate_user! => true)
    end

    it 'should require the user to be signed in' do
      controller.should_receive(:authenticate_user!)
      post :update, valid_attributes
    end

    context 'with valid params' do
      before(:each) do
        post :update, valid_attributes
      end

      it 'should redirected to the index page' do
        expect(response).to redirect_to events_path
      end

      it 'should render a success flash message' do
        expect(flash[:notice]).to eq 'Event Updated'
      end
    end

    context 'with invalid params' do
      before(:each) do
        post :update, id: @event, event: { name: nil }.as_json
      end

      it 'should redirect to the event edit page' do
        expect(response).to redirect_to edit_event_path(@event)
      end

      it 'should render a failure flash message' do
        expect(flash[:alert]).to match 'Failed to update event'
      end
    end
  end

  describe 'PATCH update_only_url' do
    let(:valid_attributes) { { id: @event, event: { url: 'http://somewhere.net' } } }

    before(:each) do
      controller.stub(:authenticate_user! => true)
    end

    it 'should require user to be signed in' do
      controller.should_receive(:authenticate_user!)
      patch :update_only_url, valid_attributes
    end

    context 'with a valid url' do
      before(:each) do
        patch :update_only_url, valid_attributes
      end

      it 'should redirect to event show page' do
        expect(response).to redirect_to event_path(@event)
      end

      it 'should render a successful flash message' do
        expect(flash[:notice]).to eq 'Event URL has been updated'
      end
    end

    context 'with an invalid url' do
      before(:each) do
        patch :update_only_url, id: @event, event: { url: 'not-a-real-url' }
      end

      it 'should redirect to the event show page' do
        expect(response).to redirect_to event_path(@event)
      end

      it 'should render a failure flash message' do
        expect(flash[:alert]).to eq 'You have to provide a valid hangout url'
      end
    end
  end
end
