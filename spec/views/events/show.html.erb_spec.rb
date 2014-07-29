require 'spec_helper'
include EventHelper

describe 'events/show', type: :view do
  before(:each) do
    ENV['TZ'] = 'UTC'
    Delorean.time_travel_to(Time.parse('Mon, 17 Feb 2013'))
    @event = stub_model(Event, name: 'EuroAsia Scrum',
                        category: 'Scrum',
                        description: 'EuroAsia Scrum and Pair hookup',
                        event_date: 'Mon, 17 Feb 2013',
                        start_time: '2000-01-01 09:00:00 UTC',
                        end_time: '2000-01-01 09:30:00 UTC',
                        updated_at: Time.now,
                        repeats: 'daily',
                        repeats_every_n_days: 1,
                        repeat_ends: 'never',
                        repeat_ends_on: 'Mon, 17 Jun 2014',
                        time_zone: 'Eastern Time (US & Canada)')
    @event_schedule = @event.next_occurrences
  end

  after (:each) do
    Delorean.back_to_the_present
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

  it 'should render dates and time for 5 upcoming events' do
    render
    expect(rendered).to have_text('Upcoming schedule')
    @event_schedule.first(5).each do |e|
      expect(rendered).to have_content(current_occurrence_time(e))
    end
  end

  it 'renders Edit event for signed in user' do
    allow(view).to receive(:user_signed_in?).and_return(true)
    render
    expect(rendered).to have_link 'Edit schedule'
  end

  describe 'Hangouts' do
    before(:each) do
      @hangout = double(Hangout, event_id: 375,
                        hangout_url: 'http://hangout.test',
                        updated_at: Time.parse('10:25:00'),
                        started?: true,
                        live?: true)
      @event.url = @hangout.hangout_url
      assign :hangout, @hangout
    end

    context 'for signed in users' do
      before do
        allow(view).to receive(:user_signed_in?).and_return(true)
        allow(view).to receive(:topic).and_return('Topic')
      end

      it_behaves_like 'it has a hangout button' do
        let(:topic_name){'Topic'}
        let(:id){@event.id}
      end

      it 'renders Edit link' do
        render
        expect(rendered).to have_content("Edit hangout link")
      end

      it 'renders Edit link form' do
        render

        expect(rendered).to have_field('hangout_url')
        expect(rendered).to have_button('Cancel')
        expect(rendered).to have_button('Save')
      end

      it 'renders Edit link form hidden' do
        render
        expect(rendered).to have_css("div.edit-link-panel")
      end

      context 'hangout has not started' do
        before :each do
          allow(@hangout).to receive(:started?).and_return(false)
        end

        it 'hides Restart hangout section' do
          render
          expect(rendered).to have_css('div.restart-panel')
        end
      end

      context 'hangout has started' do
        it 'renders restart hangout section' do
          render
          expect(rendered).to have_content("Restart hangout")
          expect(rendered).to have_css('div.restart-panel.in')
        end

        it 'renders a warning message when restarting the hangout' do
          render
          expect(rendered).to have_content("Restarting Hangout would update the details of the hangout currently associated with this event.")
        end

        it 'hides the hangout button and warning message' do
          render
          expect(rendered).to have_css('div.restart-section')
        end
      end
    end

    context 'for all users' do
      before :each do
        allow(view).to receive(:user_signed_in?).and_return(false)
      end

      context 'hangout has started' do
        before :each do
          allow(Time).to receive(:now).and_return(Time.parse('10:30:00'))
          allow(@hangout).to receive(:started?).and_return(true)
          allow(@hangout).to receive(:live?).and_return(true)
        end

        it 'renders Hangout details section' do
          render
          expect(rendered).to have_content 'Title'
          expect(rendered).to have_content 'EuroAsia Scrum'
          expect(rendered).to have_content 'Category'
          expect(rendered).to have_content 'Scrum'
          expect(rendered).to have_content('Hangout link')
          expect(rendered).to have_link('http://hangout.test', href: 'http://hangout.test')
          expect(rendered).to have_content('Updated:')
          expect(rendered).to have_content('5 minutes')
        end

        it 'renders Join link if hangout is live' do
          render
          expect(rendered).to have_link("EVENT IS LIVE", href: 'http://hangout.test')
        end

      end

      context 'hangout has not started' do
        before :each do
          allow(@hangout).to receive(:started?).and_return(false)
        end

        it 'does not render Hangout details section' do
          render
          expect(rendered).not_to have_selector(".hangout_details")
        end
      end

    end

    context 'hangout is live' do
      before :each do
        allow(@hangout).to receive(:started?).and_return(true)
        allow(@hangout).to receive(:live?).and_return(true)
      end

      it 'renders Join link if hangout is live' do
        render
        expect(rendered).to have_link("EVENT IS LIVE", href: 'http://hangout.test')
      end

    end

    context 'hangout is not live' do
      before :each do
        allow(@hangout).to receive(:started?).and_return(true)
        allow(@hangout).to receive(:live?).and_return(false)
      end

      it 'renders Join link if hangout is live' do
        render
        expect(rendered).not_to have_link("EVENT IS LIVE")
      end

    end
  end
end
