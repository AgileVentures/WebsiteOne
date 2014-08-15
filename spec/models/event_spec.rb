require 'spec_helper'

describe Event do
  it 'should respond to friendly_id' do
    expect(Event.new).to respond_to(:friendly_id)
  end

  it 'should respond to "schedule" method' do
    Event.respond_to?('schedule')
  end

  it 'return the latest hangout' do
    event = FactoryGirl.create(:event)
    Hangout.create(id: 1, event_id: event.id)
    Hangout.create(id: 2, event_id: event.id)

    expect(event.last_hangout.id).to eq(2)
  end

  context 'return false on invalid inputs' do
    before do
      @event = FactoryGirl.create(:event)
    end
    it 'nil :name' do
      @event.name = ''
      expect(@event.save).to be_falsey
    end

    it 'nil :category' do
      @event.category = nil
      expect(@event.save).to be_falsey
    end

    it 'nil :repeats' do
      @event.repeats = nil
      expect(@event.save).to be_falsey
    end
  end

  context 'should create a scrum event that ' do
    it 'is scheduled for one occasion' do
      event = FactoryGirl.build_stubbed(Event,
                                        name: 'one time event',
                                        category: 'Scrum',
                                        description: '',
                                        start_datetime: 'Mon, 17 Jun 2013 09:00:00 UTC',
                                        duration: 600,
                                        repeats: 'never',
                                        repeats_every_n_weeks: nil,
                                        repeat_ends: 'never',
                                        repeat_ends_on: 'Mon, 17 Jun 2013',
                                        time_zone: 'Eastern Time (US & Canada)')
      expect(event.schedule.first(5)).to eq(['Mon, 17 Jun 2013 09:00:00 UTC +00:00'])
    end

    it 'is scheduled for every weekend' do
      event = FactoryGirl.build_stubbed(Event,
                                        name: 'every weekend event',
                                        category: 'Scrum',
                                        description: '',
                                        start_datetime: 'Mon, 17 Jun 2013 09:00:00 UTC',
                                        duration: 600,
                                        repeats: 'weekly',
                                        repeats_every_n_weeks: 1,
                                        repeats_weekly_each_days_of_the_week_mask: 96,
                                        repeat_ends: 'never',
                                        repeat_ends_on: 'Tue, 25 Jun 2013',
                                        time_zone: 'Eastern Time (US & Canada)')
      expect(event.schedule.first(5)).to eq(['Sat, 22 Jun 2013 09:00:00 UTC +00:00', 'Sun, 23 Jun 2013 09:00:00 UTC +00:00', 'Sat, 29 Jun 2013 09:00:00 UTC +00:00', 'Sun, 30 Jun 2013 09:00:00 UTC +00:00', 'Sat, 06 Jul 2013 09:00:00 UTC +00:00'])
    end

    it 'is scheduled for every Sunday' do
      event = FactoryGirl.build_stubbed(Event,
                                        name: 'every Sunday event',
                                        category: 'Scrum',
                                        description: '',
                                        start_datetime: 'Mon, 17 Jun 2013 09:00:00 UTC',
                                        duration: 600,
                                        repeats: 'weekly',
                                        repeats_every_n_weeks: 1,
                                        repeats_weekly_each_days_of_the_week_mask: 64,
                                        repeat_ends: 'never',
                                        repeat_ends_on: 'Mon, 17 Jun 2013',
                                        time_zone: 'Eastern Time (US & Canada)')
      expect(event.schedule.first(5)).to eq(['Sun, 23 Jun 2013 09:00:00 UTC +00:00', 'Sun, 30 Jun 2013 09:00:00 UTC +00:00', 'Sun, 07 Jul 2013 09:00:00 UTC +00:00', 'Sun, 14 Jul 2013 09:00:00 UTC +00:00', 'Sun, 21 Jul 2013 09:00:00 UTC +00:00'])
    end

    it 'is scheduled for every Monday' do
      event = FactoryGirl.build_stubbed(Event,
                                        name: 'every Monday event',
                                        category: 'Scrum',
                                        description: '',
                                        start_datetime: 'Mon, 17 Jun 2013 09:00:00 UTC',
                                        duration: 600,
                                        repeats: 'weekly',
                                        repeats_every_n_weeks: 1,
                                        repeats_weekly_each_days_of_the_week_mask: 1,
                                        repeat_ends: 'never',
                                        repeat_ends_on: 'Mon, 17 Jun 2013',
                                        time_zone: 'UTC')
      expect(event.schedule.first(5)).to eq(['Mon, 17 Jun 2013 09:00:00 GMT +00:00', 'Mon, 24 Jun 2013 09:00:00 GMT +00:00', 'Mon, 01 Jul 2013 09:00:00 GMT +00:00', 'Mon, 08 Jul 2013 09:00:00 GMT +00:00', 'Mon, 15 Jul 2013 09:00:00 GMT +00:00'])
    end

    it 'should mark as active events which have started and have not ended' do
      @event = FactoryGirl.build_stubbed(Event,
                                         name: 'every Monday event',
                                         category: 'Scrum',
                                         description: '',
                                         start_datetime: 'Mon, 17 Jun 2014 09:00:00 UTC',
                                         duration: 600,
                                         repeats: 'weekly',
                                         repeats_every_n_weeks: 1,
                                         repeats_weekly_each_days_of_the_week_mask: 1,
                                         repeat_ends: 'never',
                                         repeat_ends_on: 'Mon, 17 Jun 2013',
                                         time_zone: 'UTC')
      hangout = @event.hangouts.create(hangout_url: 'anything@anything.com',
                                       updated_at: '2014-06-17 10:25:00 UTC')
      Delorean.time_travel_to(Time.parse('2014-06-17 10:26:00 UTC'))
      expect(@event.live?).to be_truthy
    end

    it 'should mark as NOT live events which have ended' do
      @event = FactoryGirl.build_stubbed(Event,
                                         name: 'every Monday event',
                                         category: 'Scrum',
                                         description: '',
                                         start_datetime: 'Mon, 17 Jun 2014 09:00:00 UTC',
                                         duration: 600,
                                         repeats: 'weekly',
                                         repeats_every_n_weeks: 1,
                                         repeats_weekly_each_days_of_the_week_mask: 1,
                                         repeat_ends: 'never',
                                         repeat_ends_on: 'Mon, 17 Jun 2013',
                                         time_zone: 'UTC')
      hangout = @event.hangouts.create(hangout_url: 'anything@anything.com',
                                       updated_at: '2014-06-17 10:20:00 UTC')
      Delorean.time_travel_to(Time.parse('2014-06-17 10:26:00 UTC'))
      expect(@event.live?).to be_falsey
    end
  end

  context 'should create a hookup event that' do
    before do
      @event = FactoryGirl.build_stubbed(Event,
                                         name: 'PP Monday event',
                                         category: 'PairProgramming',
                                         start_datetime: 'Mon, 17 Jun 2014 09:00:00 UTC',
                                         duration: 90,
                                         repeats: 'never',
                                         time_zone: 'UTC')
    end

    it 'should expire events that ended' do
      hangout = @event.hangouts.create(hangout_url: 'anything@anything.com',
                                       updated_at: '2014-06-17 10:25:00 UTC')
      allow(hangout).to receive(:started?).and_return(true)
      Delorean.time_travel_to(Time.parse('2014-06-17 10:31:00 UTC'))
      expect(@event.live?).to be_falsey
    end

    it 'should mark as active events which have started and have not ended' do
      hangout = @event.hangouts.create(hangout_url: 'anything@anything.com',
                                       updated_at: '2014-06-17 10:25:00 UTC')
      Delorean.time_travel_to(Time.parse('2014-06-17 10:26:00 UTC'))
      expect(@event.live?).to be_truthy
    end

    it 'should not be started if events have not started' do
      hangout = @event.hangouts.create(hangout_url: nil,
                                       updated_at: nil)
      Delorean.time_travel_to(Time.parse('2014-06-17 9:30:00 UTC'))
      expect(@event.live?).to be_falsey
    end
  end

  context 'Event url' do
    before (:each) do
      @event = {name: 'one time event',
                category: 'Scrum',
                description: '',
                start_datetime: 'Mon, 17 Jun 2013 09:00:00 UTC',
                duration: 600,
                repeats: 'never',
                repeats_every_n_weeks: nil,
                repeat_ends: 'never',
                repeat_ends_on: 'Mon, 17 Jun 2013',
                time_zone: 'Eastern Time (US & Canada)'}
    end

    it 'should be set if valid' do
      event = Event.create!(@event.merge(:url => 'http://google.com'))
      expect(event.save).to be_truthy
    end

    it 'should be rejected if invalid' do
      event = Event.create(@event.merge(:url => 'http:google.com'))
      event.should have(1).error_on(:url)
    end
  end

  describe 'Event#next_occurences' do
    before do
      @event = FactoryGirl.build_stubbed(Event,
                                         name: 'Spec Scrum',
                                         start_datetime: '2014-03-07 10:30:00 UTC',
                                         time_zone: 'UTC',
                                         duration: 30)

      allow(@event).to receive(:repeats).and_return('weekly')
      allow(@event).to receive(:repeats_every_n_weeks).and_return(1)
      allow(@event).to receive(:repeats_weekly_each_days_of_the_week_mask).and_return(0b1111111)
      allow(@event).to receive(:repeat_ends).and_return(true)
      allow(@event).to receive(:repeat_ends_on).and_return('Tue, 25 Jun 2015')
      allow(@event).to receive(:friendly_id).and_return('spec-scrum')
    end

    let(:options) { {} }
    let(:next_occurrences) { @event.next_occurrences(options) }
    let(:next_occurrence_time) { next_occurrences.first[:time].time }

    it 'should return the next occurence of the event' do
      Delorean.time_travel_to(Time.parse('2014-03-07 09:27:00 UTC'))
      expect(next_occurrence_time).to eq(Time.parse('2014-03-07 10:30:00 UTC'))
    end

    it 'includes the event that has been started within the last 30 minutes' do
      Delorean.time_travel_to(Time.parse('2014-03-07 10:50:00 UTC'))
      expect(next_occurrence_time).to eq(Time.parse('2014-03-07 10:30:00 UTC'))
    end

    it 'does not include the event that has been started within more than 30 minutes ago' do
      Delorean.time_travel_to(Time.parse('2014-03-07 11:01:00 UTC'))
      expect(next_occurrence_time).to eq(Time.parse('2014-03-08 10:30:00 UTC'))
    end

    context 'test against start_datetime and repeat_ends_on' do
      it 'starts in the future' do
        Delorean.time_travel_to(Time.parse('2014-03-01 09:27:00 UTC'))
        expect(next_occurrence_time).to eq(Time.parse('2014-03-07 10:30:00 UTC'))
      end

      it 'already ended in the past' do
        Delorean.time_travel_to(Time.parse('2016-02-07 09:27:00 UTC'))
        expect(next_occurrences.count).to eq(0)
      end
    end

    context 'with input arguments' do
      context ':limit option' do
        let(:options) { { limit: 2 } }

        it 'should limit the size of the output' do
          Delorean.time_travel_to(Time.parse('2014-03-08 09:27:00 UTC'))
          expect(next_occurrences.count).to eq(2)
        end
      end

      context ':start_time option' do
        let(:options) { { start_time: Time.parse('2014-03-09 9:27:00 UTC') } }

        it 'should return only occurrences after a specific time' do
          Delorean.time_travel_to(Time.parse('2014-03-05 09:27:00 UTC'))
          expect(next_occurrence_time).to eq(Time.parse('2014-03-09 10:30:00 UTC'))
        end
      end
    end
  end

  describe 'Event#final_datetime_for_display for ending event' do
    before do
      @event = FactoryGirl.build_stubbed(Event,
                                         name: 'Spec Scrum never ends',
                                         start_datetime: '2014-03-07 10:30:00 UTC',
                                         duration: 30,
                                         repeats: 'weekly',
                                         repeats_every_n_weeks: 1,
                                         repeats_weekly_each_days_of_the_week_mask: 0b1111111,
                                         repeat_ends: true,
                                         repeat_ends_on: '2015-6-25')
    end

    let(:options) { {} }
    let(:next_occurrences) { @event.next_occurrences(options) }
    let(:next_occurrence_time) { next_occurrences.first[:time].time }

    it 'should return the repeat_ends_on datetime if that comes first and it is a repeating event and the ends_on datetime is less than 10 days away' do
      Delorean.time_travel_to(Time.parse('2015-06-23 09:27:00 UTC'))
      options[:end_time] = '2015-06-30 09:27:00 UTC'
      expect(@event.final_datetime_in_collection(options)).to eq(@event.repeat_ends_on.to_datetime)
    end

    it 'should return the options[:endtime] if that comes before repeat_ends_on' do
      Delorean.time_travel_to(Time.parse('2015-06-15 09:27:00 UTC'))
      options[:end_time] = '2015-06-20 09:27:00 UTC'
      expect(@event.final_datetime_in_collection(options)).to eq(options[:end_time].to_datetime)
    end

    it 'should return the repeat_ends_on datetime if there is no options[end_time] and the ends_on datetime is less than 10 days away' do
      Delorean.time_travel_to(Time.parse('2015-06-23 09:27:00 UTC'))
      expect(@event.final_datetime_in_collection).to eq(@event.repeat_ends_on.to_datetime)
    end

    it 'should return 10 days from now if that is soonest of the options' do
      Delorean.time_travel_to(Time.parse('2015-06-10 09:27:00 UTC'))
      options[:end_time] = '2015-06-28 09:27:00 UTC'
      ten_days_from_now = (Time.now + 10.days).utc.to_datetime
      expect(@event.final_datetime_in_collection(options).utc.to_datetime.to_s).to eql(ten_days_from_now.to_s)
    end
  end

  describe 'Event#final_datetime_for_display for never-ending event' do
    before do
      @event = FactoryGirl.build_stubbed(Event,
                                         name: 'Spec Scrum never-ending',
                                         start_datetime: '2014-03-07 10:30:00 UTC',
                                         duration: 30,
                                         repeats: 'weekly',
                                         repeats_every_n_weeks: 1,
                                         repeats_weekly_each_days_of_the_week_mask: 0b1111111,
                                         repeat_ends: false)
    end

    let(:options) { {} }
    let(:next_occurrences) { @event.next_occurrences(options) }
    let(:next_occurrence_time) { next_occurrences.first[:time].time }

    it 'should return the options[:endtime] if that comes before 10 days from now' do
      Delorean.time_travel_to(Time.parse('2015-06-15 09:27:00 UTC'))
      options[:end_time] = '2015-06-20 09:27:00 UTC'
      expect(@event.final_datetime_in_collection(options)).to eq(options[:end_time].to_datetime)
    end

    it 'should return three days from now if there is no options[end_time]' do
      Delorean.time_travel_to(Time.parse('2015-06-23 09:27:00 UTC'))
      options[:time_in_future] = 3.days
      expect(@event.final_datetime_in_collection(options).to_datetime.to_s).to eq(3.days.from_now.to_datetime.to_s)
    end

    it 'should return the options[:endtime] if the event never ends and option[:endtime] is less than the time_in_future.from_now' do
      Delorean.time_travel_to(Time.parse('2015-06-23 09:27:00 UTC'))
      options[:end_time] = '2015-06-28 09:27:00 UTC'
      options[:time_in_future] = 7.days
      expect(@event.final_datetime_in_collection(options)).to eq(options[:end_time].to_datetime)
    end

    it 'should return 10 days from now if that is soonest of the options' do
      Delorean.time_travel_to(Time.parse('2015-06-10 09:27:00 UTC'))
      options[:end_time] = '2015-06-28 09:27:00 UTC'
      ten_days_from_now = (Time.now + 10.days).utc.to_datetime
      expect(@event.final_datetime_in_collection(options).utc.to_datetime.to_s).to eql(ten_days_from_now.to_s)
    end
  end

  describe 'Event.next_event_occurence' do
    let(:event) do
      Event.new(
          name: 'Spec Scrum',
          start_datetime: '2014-03-07 10:30:00 UTC',
          category: 'Scrum',
          duration: 30,
          repeats: 'never',
          repeat_ends: true,
          repeat_ends_on: '')
    end

    before(:each) do
      Event.stub(:exists?).and_return true
      Event.stub(:where).and_return [ event ]
    end

    it 'should return the next event occurence' do
      Delorean.time_travel_to(Time.parse('2014-03-07 09:27:00 UTC'))
      expect(Event.next_event_occurrence).to eq event
    end

    it 'should have a 15 minute buffer' do
      Delorean.time_travel_to(Time.parse('2014-03-07 10:44:59 UTC'))
      expect(Event.next_event_occurrence).to eq event
    end

    it 'should not return events that occured more than 15 minutes ago' do
      Delorean.time_travel_to(Time.parse('2014-03-07 10:45:01 UTC'))
      expect(Event.next_event_occurrence).to be_nil
    end
  end
end