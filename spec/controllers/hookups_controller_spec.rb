require 'spec_helper'

describe HookupsController, type: :controller do
  it 'assigns a pending hookup to the view' do
    event = FactoryGirl.create Event, category: "PairProgramming"
    @hangout = FactoryGirl.create(:hangout,
                                  event_id: event.id)
    allow_any_instance_of(Event).to receive(:last_hangout).and_return(@hangout)
    allow_any_instance_of(Event).to receive(:end_time).and_return(1.hour.from_now)
    get :index
    expect(assigns(:pending_hookups)[0]).to eq(event)
  end

  it 'assigns an active hookup for the view' do
    @event = FactoryGirl.create Event, category: "PairProgramming"
    @hangout = @event.hangouts.create(hangout_url: 'anything@anything.com',
                                      updated_at: 1.minute.ago,
                                      category: "PairProgramming")
    get :index
    expect(assigns(:active_pp_hangouts)[0]).to eq(@hangout)
  end

  context 'POST create_hookup with valid attributes' do
    it 'redirects to hookups' do
      post :create, valid_attributes_hookup
      expect(response).to redirect_to :hookups
    end

    it 'saves the new event in the database' do
      expect {
        post :create, valid_attributes_hookup
      }.to change(Event, :count).by(1)
    end

    it 'saves the new event with the correct title' do
      post :create, valid_attributes_hookup
      @event = assigns(:event)
      expect(@event.name).to eq(valid_attributes_hookup['title'])
    end

    it 'saves the new event with the correct duration' do
      post :create, valid_attributes_hookup
      @event = assigns(:event)
      expect(@event.duration).to eq(valid_attributes_hookup['duration'])
    end

    it 'saves the new event with the correct datetime' do
      post :create, valid_attributes_hookup
      @event = assigns(:event)
      datetime_in = Time.utc(valid_attributes_hookup['start_date'].to_date.year,
                             valid_attributes_hookup['start_date'].to_date.month,
                             valid_attributes_hookup['start_date'].to_date.day,
                             valid_attributes_hookup['start_time'].to_time.hour,
                             valid_attributes_hookup['start_time'].to_time.min,
                             valid_attributes_hookup['start_time'].to_time.sec)
      expect(@event.start_datetime).to eq(datetime_in)
    end
  end

  context 'POST create_hookup with invalid attributes' do
    it 'does not save the new subject in the database' do
      #Event.any_instance.stub(:save).and_return(false)
      expect {
        post :create, invalid_attributes_hookup
      }.to_not change(Event, :count)
      assigns(:event).should be_a_new(Event)
      assigns(:event).should_not be_persisted
    end

    it 're-renders the hookups' do
      Event.any_instance.stub(:save).and_return(false)
      post :create, invalid_attributes_hookup
      expect(response).to redirect_to :hookups
    end
  end
end