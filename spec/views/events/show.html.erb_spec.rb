require 'spec_helper'
include EventHelper
include LocalTimeHelper

describe 'events/show', type: :view do
  before(:each) do
    @event = FactoryGirl.build_stubbed(Event, name: 'EuroAsia Scrum',
                        category: 'Scrum',
                        description: 'EuroAsia Scrum and Pair hookup',
                        time_zone: 'Eastern Time (US & Canada)')

    allow(Time).to receive(:now).and_return(Time.parse('2014-03-07 23:30:00 UTC'))
    @event_schedule = @event.next_occurrences(end_time: Time.now + 40.days)

    allow(view).to receive(:current_user).and_return(FactoryGirl.build_stubbed(:user))
  end

  it 'should display event information' do
    render
    expect(rendered).to have_text('EuroAsia Scrum')
    expect(rendered).to have_text('EuroAsia Scrum and Pair hookup')
  end

  it 'should render the event name' do
    render
    expect(rendered).to have_text(@event.name)
  end

  it 'should render the event description' do
    render
    expect(rendered).to have_text(@event.description)
  end

  describe 'Hangouts' do
    before(:each) do
      @recent_hangout = FactoryGirl.build_stubbed(:event_instance,
                        uid: '123456',
                        event_id: 375,
                        category: 'Scrum',
                        hangout_url: 'http://hangout.test',
                        updated: Time.parse('10:25:00 UTC'))

      allow(@recent_hangout).to receive(:started?).and_return true
      allow(@recent_hangout).to receive(:live?).and_return true
      allow(view).to receive(:generate_event_instance_id).and_return('123456')

      @event.url = @recent_hangout.hangout_url
    end

    context 'hangout is live' do
      before :each do
        allow(@recent_hangout).to receive(:started?).and_return(true)
        allow(@recent_hangout).to receive(:live?).and_return(true)
      end

      it 'renders Join link if hangout is live' do
        render
        expect(rendered).to have_link('Join now', href: 'http://hangout.test')
      end
    end

    context 'for signed in users' do
      before do
        allow(view).to receive(:user_signed_in?).and_return(true)
        allow(view).to receive(:topic).and_return('Topic')
      end

      it_behaves_like 'it has a hangout button' do
        let(:title){'Topic'}
        let(:project_id){''}
        let(:event_id){@event.id}
        let(:category){@event.category}
        let(:event_instance_id){@recent_hangout.uid}
      end
    end
  end
end
