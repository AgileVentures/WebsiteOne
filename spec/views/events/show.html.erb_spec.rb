require 'spec_helper'

describe 'events/show' do
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
    # render
  end

  after (:each) do
    Delorean.back_to_the_present
  end

  it 'should display event information' do
    render
    rendered.should have_text 'EuroAsia Scrum'
    rendered.should have_text 'EuroAsia Scrum and Pair hookup'
  end

  it 'should render the event name' do
    render
    rendered.should have_text @event.name
  end

  it 'should render the event description' do
    render
    rendered.should have_text @event.description
  end

  it 'should render dates and time for 5 upcoming events' do
    render
    rendered.should have_text 'Upcoming schedule'
    @event_schedule.first(5).each do |e|
      rendered.should have_content nested_hash_value(e, :time).strftime('%F at %I:%M%p')
    end
  end

  it 'renders Edit event for signed in user' do
    view.stub(:user_signed_in?).and_return(true)
    render
    expect(rendered).to have_link 'Edit'
  end

  describe 'Hangouts' do
    before(:each) do
      @hangout = stub_model(Hangout, event_id: 375,
                            hangout_url: 'http://hangout.test',
                            updated_at: Time.parse('10:25:00'),
                            started?: true)
      @event.url = @hangout.hangout_url
      assign :hangout, @hangout
    end

    context 'for signed in users' do
      before do
        view.stub(user_signed_in?: true)
        view.stub(topic: 'Topic')
      end

      it_behaves_like 'it has a hangout button' do
        let(:topic_name){'Topic'}
        let(:id){@event.id}
      end

      it 'renders Edit link button' do
        Time.stub(now: Time.parse('10:30:00'))
        render
        expect(rendered).to have_button('Edit hangout link manually')
        expect(rendered).to have_content('Updated:')
        expect(rendered).to have_content('5 minutes')
      end

      it 'renders Edit link form' do
        render
        expect(rendered).not_to have_css('#form-edit-link', visible: true)

        expect(rendered).to have_content("Enter the link for manually created hangout:")
        expect(rendered).to have_field('hangout_url', visible: false)
        expect(rendered).to have_button('Cancel', visible: false)
        expect(rendered).to have_button('Save', visible: false)
      end

      context 'hangout has not started' do
        before :each do
          @hangout.stub(started?: false)
        end
        it 'does not render Restart HOA button' do
          render
          expect(rendered).not_to have_css('#restart-hoa', visible: true)
        end

        it 'does not show a warning message when restarting the hangout' do
          render
          expect(rendered).not_to have_css('#restart-warning', visible: true)
        end
      end

      context 'hangout has started' do
        it 'hides the Hangout button' do
          render
          expect(rendered).not_to have_css('#hangout_button', visible: true)
        end

        it 'renders Restart HOA button' do
          render
          expect(rendered).to have_button("Click to restart the hangout")
        end

        it 'renders a warning message when restarting the hangout' do
          render
          expect(rendered).not_to have_css('#restart-warning', visible: true)
          expect(rendered).to have_content("Restarting Hangout would update the details of the hangout currently associated with this event.")
        end
      end
    end

    context 'for all users' do
      before :each do
        view.stub(user_signed_in?: false)
      end
      context 'hangout has started' do
        before :each do
          @hangout.stub(started?: true)
        end

        it 'renders Hangout details section' do
          render
          expect(rendered).to have_selector("#hangout_details")
          expect(rendered).to have_content 'Title'
          expect(rendered).to have_content 'EuroAsia Scrum'
          expect(rendered).to have_content 'Category'
          expect(rendered).to have_content 'Scrum'
          expect(rendered).to have_link('Click to join the hangout', href: 'http://hangout.test')
        end

      end

      context 'hangout has not started' do
        before :each do
          @hangout.stub(started?: false)
        end

        it 'does not render Hangout details section' do
          render
          expect(rendered).not_to have_selector("#hangout_details")
        end
      end

    end
  end
end
