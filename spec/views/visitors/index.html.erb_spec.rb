require 'spec_helper'

def fix_time_at(time)
  fix_time = Time.parse(time)
  allow(Time).to receive(:now).and_return(fix_time)
end

describe 'visitors/index.html.erb', type: :view do
  before :each do
    @event = FactoryGirl.build_stubbed(:event, name: 'Spec Scrum', event_date: '2014-03-07', start_time: '10:30:00',
                                        next_occurrence_time: double(IceCube::Occurrence, to_datetime:DateTime.parse('2014-03-07 10:30:00 UTC')))
  end

  context 'event is planned for next day' do
    before :each do
      fix_time_at('2014-03-05 09:15:00 UTC')
    end

    it 'should display countdown' do
      render
      expect(rendered).to have_link @event.name, event_path(@event)
      expect(rendered).to have_text [@event.name, 'in'].join(' ')
      expect(rendered).to have_text '2 days'
      expect(rendered).to have_text '1 hour'
      expect(rendered).to have_text '15 minutes'
    end
  end

  context 'event is planned for same day' do
    before :each do
      fix_time_at('2014-03-07 09:15:00 UTC')
    end

    it 'should display countdown but skip the "O days"' do
      render
      expect(rendered).to have_link @event.name, event_path(@event)
      expect(rendered).to have_text [@event.name, 'in'].join(' ')
      expect(rendered).to_not have_text '0 days'
      expect(rendered).to have_text '1 hour'
      expect(rendered).to have_text '15 minutes'
    end
  end

  context 'event is planned for same hour' do
    before :each do
      fix_time_at('2014-03-07 10:15:00 UTC')
    end

    it 'should display countdown but skip the "O hours"' do
      render
      expect(rendered).to have_link @event.name, event_path(@event)
      expect(rendered).to have_text [@event.name, 'in'].join(' ')
      expect(rendered).to_not have_text '0 days'
      expect(rendered).to_not have_text '0 hours'
      expect(rendered).to have_text '15 minutes'
    end
  end

  context 'event has started less than 15 minutes ago' do
    before :each do
      fix_time_at('2014-03-07 10:44:00 UTC')
      @event.hangout = Hangout.new(hangout_url: 'http://hangout.test')
    end

    it 'should <event> has just started!' do
      render
      expect(rendered).to have_link @event.name, event_path(@event)
      expect(rendered).to have_text 'is live!'
    end

    it 'renders Join live event link if hangout is live' do
      allow(@event.hangout).to receive(:live?).and_return(true)
      render
      expect(rendered).to have_link('Click to join!', href: 'http://hangout.test')
    end

    it 'does not render Join live event link if hangout is not live' do
      allow(@event.hangout).to receive(:live?).and_return(false)
      render
      expect(rendered).not_to have_link('Click to join!', href: 'http://hangout.test')
    end
  end

  context 'event is planned within 23h (testing display of -1 h) ' do
    before :each do
      fix_time_at('2014-03-06 10:45:00 UTC')
    end

    it 'should display countdown without -1' do
      render
      expect(rendered).to have_link @event.name, event_path(@event)
      expect(rendered).to have_text [@event.name, 'in'].join(' ')
      expect(rendered).to_not have_text '-1 hours'
      expect(rendered).to have_text '23 hours'
      expect(rendered).to have_text '45 minutes'
    end
  end

  context 'correct pluralization of countdown' do
    context 'days' do
      it 'should be singular for 1 day' do
        fix_time_at('2014-03-06 10:15:00 UTC')
        render
        expect(rendered).to have_text '1 day'
        expect(rendered).to_not have_text '1 days'
      end
      it 'should be plural for 2 days' do
        fix_time_at('2014-03-05 10:15:00 UTC')
        render
        expect(rendered).to have_text '2 days'
      end
    end
    context 'hours' do
      it 'should be singular for 1 hour' do
        fix_time_at('2014-03-07 09:15:00 UTC')
        render
        expect(rendered).to have_text '1 hour'
        expect(rendered).to_not have_text '1 hours'
      end
      it 'should be plural for 2 hours' do
        fix_time_at('2014-03-07 8:15:00 UTC')
        render
        expect(rendered).to have_text '2 hours'
      end
    end
    context 'minutes' do
      it 'should be singular for 1 minute' do
        fix_time_at('2014-03-07 10:29:00 UTC')
        render
        expect(rendered).to have_text '1 minute'
        expect(rendered).to_not have_text '1 minutes'
      end
      it 'should be plural of 5 minutes' do
        fix_time_at('2014-03-07 10:25:00 UTC')
        render
        expect(rendered).to have_text '5 minutes'
      end
    end
  end
end
