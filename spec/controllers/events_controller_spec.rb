require 'spec_helper'

describe EventsController do
  let(:event) { @event }
  let(:valid_session) { {} }

  before :each do
    @event = FactoryGirl.create(:event)
    debugger
    @events = Event.all
    #@events = [@event]
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
          post :create, event: attributes_for(:event)
        }.to change(Event, :count).by(1)
      end

      it 'redirects to events#show' do
        Event.any_instance.stub(:save).and_return(true)
        post :create, event: attributes_for(:event)
        expect(response).to redirect_to events_path
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new subject in the database' do
        Event.any_instance.stub(:save).and_return(false)
        expect {
          post :create, event: attributes_for(:event)
        }.to_not change(Event, :count)
        assigns(:event).should be_a_new(Event)
        assigns(:event).should_not be_persisted
      end

      it 're-renders the events#new template' do
        Event.any_instance.stub(:save).and_return(false)
        post :create, event: attributes_for(:event)
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
end
