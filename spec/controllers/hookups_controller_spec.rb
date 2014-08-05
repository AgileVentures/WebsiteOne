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
end
