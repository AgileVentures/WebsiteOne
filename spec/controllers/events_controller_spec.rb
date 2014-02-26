require 'spec_helper'
require 'webmock/rspec'

describe EventsController do
  let(:event) { @event }
  let(:invalid_event) { {'name' => nil } }
  let(:valid_attributes) { {
      'name' => 'one time event',
      'description' => '',
      'is_all_day' => false,
      'from_date' => 'Mon, 17 Jun 2013',
      'from_time' => '2000-01-01 09:00:00 UTC',
      'to_date' => 'Mon, 17 Jun 2013',
      'to_time' => '2000-01-01 09:14:00 UTC',
      'repeats' => 'never',
      'repeats_every_n_days' => nil,
      'repeats_every_n_weeks' => nil,
      'repeats_every_n_months' => nil,
      'repeats_monthly' => 'each',
      'repeats_every_n_years' => nil,
      'repeats_yearly_on' => false,
      'repeat_ends' => 'never',
      'repeat_ends_on' => 'Mon, 17 Jun 2013',
      'time_zone' => 'Eastern Time (US & Canada)'} }

  let(:valid_session) { {} }

  before :each do
    @event = FactoryGirl.create(:event)

    @events = [@event]
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

    it "renders the :edit template" do
      get :edit, id: @event
      expect(response).to render_template :edit
    end
  end




  #it 'should render "show"' do
  #  get :show, {:id=>event.to_param}, valid_session
  #  assigns(:event).should eq(event)
  #  response.should render_template :show
  #end


  #it 'should render "edit"' do
  #  get :edit, {:id=>event.to_param}, valid_session
  #  assigns(:event).should eq(@event)
  #  response.should render_template :edit
  #end

end
