require 'spec_helper'

describe HookupsController, type: :controller do
  let(:event){ FactoryGirl.create(:event, category: 'PairProgramming') }
  let(:hangout){ FactoryGirl.create(:event_instance, event: event, category: 'PairProgramming', hangout_url: nil) }

  it 'assigns a pending hookup to the view' do
    allow_any_instance_of(Event).to receive(:last_hangout).and_return(hangout)
    allow_any_instance_of(Event).to receive(:end_time).and_return(1.hour.from_now)

    get :index
    expect(assigns(:pending_hookups)[0]).to eq(event)
  end

  it 'assigns an active hookup for the view' do
    hangout.update(updated_at: 1.minute.ago, hangout_url: 'http://hangout.test')

    get :index
    expect(assigns(:active_pp_hangouts)[0]).to eq(hangout)
  end
end
