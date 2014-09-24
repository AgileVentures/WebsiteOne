require 'spec_helper'

describe Event, :type => :model do
  subject { build_stubbed :event }

  it { is_expected.to respond_to :friendly_id }
  it { is_expected.to respond_to :schedule }
  it { is_expected.to respond_to :live? }

  it 'is valid with all the correct parameters' do
    expect(subject).to be_valid
  end

  it 'is invalid without name' do
    expect(FactoryGirl.build(:event, name: nil)).to_not be_valid
  end

  it 'is invalid without category' do
    expect(FactoryGirl.build(:event, category: nil)).to_not be_valid
  end

  it 'is invalid without repeats' do
    expect(FactoryGirl.build(:event, repeats: nil)).to_not be_valid
  end

  it 'is invalid with invalid url' do
    expect(FactoryGirl.build(:event, url: 'http:google.com')).to_not be_valid
  end

  describe '#last_hangout' do
    it 'returns the latest hangout' do
      hangout1 = subject.hangouts.create
      hangout2 = subject.hangouts.create(created_at: Date.yesterday, updated_at: Date.yesterday)

      expect(subject.last_hangout).to eq(hangout1)
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
      expect(@event).to_not be_live
    end

    it 'should mark as active events which have started and have not ended' do
      hangout = @event.hangouts.create(hangout_url: 'anything@anything.com',
                                       updated_at: '2014-06-17 10:25:00 UTC')
      Delorean.time_travel_to(Time.parse('2014-06-17 10:26:00 UTC'))
      expect(@event).to be_live
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
      expect(event.errors[:url].size).to eq(1)
    end
  end

  describe '#next_occurences' do
    before do
      @event = FactoryGirl.build_stubbed(Event,
                                         name: 'Spec Scrum',
                                         start_datetime: '2014-03-07 10:30:00 UTC',
                                         duration: 30)

      allow(@event).to receive(:repeats).and_return('weekly')
      allow(@event).to receive(:repeats_every_n_weeks).and_return(1)
      allow(@event).to receive(:repeats_weekly_each_days_of_the_week_mask).and_return(0b1111111)
      allow(@event).to receive(:repeat_ends).and_return(true)
      allow(@event).to receive(:repeat_ends_on).and_return('Tue, 25 Jun 2015')
      allow(@event).to receive(:friendly_id).and_return('spec-scrum')
    end

    it 'should return the next occurence of the event' do
      Delorean.time_travel_to(Time.parse('2014-03-07 09:27:00 UTC'))
      expect(@event.next_occurrence_time_method).to eq(Time.parse('2014-03-07 10:30:00 UTC'))
    end

    it 'includes the event that has been started within the last 15 minutes' do
      Delorean.time_travel_to(Time.parse('2014-03-07 10:44:00 UTC'))
      expect(@event.next_occurrence_time_method).to eq(Time.parse('2014-03-07 10:30:00 UTC'))
    end

    it 'does not include the event that has been started within more than 15 minutes ago' do
      options = {}
      Delorean.time_travel_to(Time.parse('2014-03-07 10:46:00 UTC'))
      expect(@event.next_occurrence_time_method).to eq(Time.parse('2014-03-08 10:30:00 UTC'))
    end

    context 'test against start_datetime and repeat_ends_on' do
      it 'starts in the future' do
        Delorean.time_travel_to(Time.parse('2014-03-01 09:27:00 UTC'))
        expect(@event.next_occurrence_time_method).to eq(Time.parse('2014-03-07 10:30:00 UTC'))
      end

      it 'already ended in the past' do
        Delorean.time_travel_to(Time.parse('2016-02-07 09:27:00 UTC'))
        expect(@event.next_occurrences.count).to eq(0)
      end
    end

    context 'with input arguments' do
      context ':limit option' do

        it 'should limit the size of the output' do
          options = { limit: 2 }
          Delorean.time_travel_to(Time.parse('2014-03-08 09:27:00 UTC'))
          expect(@event.next_occurrences(options).count).to eq(2)
        end
      end

      context ':start_time option' do
        it 'should return only occurrences after a specific time' do
          options = {start_time: Time.parse('2014-03-09 9:27:00 UTC')}
          Delorean.time_travel_to(Time.parse('2014-03-05 09:27:00 UTC'))
          expect(@event.next_occurrence_time_method(options)).to eq(Time.parse('2014-03-09 10:30:00 UTC'))
        end
      end
    end
  end

  describe 'Event#start_datetime_for_collection for starting event' do
    before do
      @event = FactoryGirl.build_stubbed(Event,
                                         name: 'Spec Scrum never ends',
                                         start_datetime: '2014-03-07 10:30:00 UTC',
                                         duration: 30)
    end

    it 'should return the start_time if it is specified' do
      Delorean.time_travel_to(Time.parse('2015-06-23 09:27:00 UTC'))
      options = {start_time: '2015-06-20 09:27:00 UTC'}
      expect(@event.start_datetime_for_collection(options)).to eq(options[:start_time])
    end

    it 'should return 30 minutes before now if start_time is not specified' do
      Delorean.time_travel_to(Time.parse('2015-06-23 09:27:00 UTC'))
      expect(@event.start_datetime_for_collection.to_datetime.to_s).to eq((Time.now - Event.collection_time_past).utc.to_datetime.to_s)
    end

    it 'should return 60 minutes before now if start_time is not specified and CollectionTimePast=60' do
      Delorean.time_travel_to(Time.parse('2015-06-23 09:27:00 UTC'))
      Event.collection_time_past=60.minutes
      expect(@event.start_datetime_for_collection.to_datetime.to_s).to eq((Time.now - Event.collection_time_past).utc.to_datetime.to_s)
      Event.collection_time_past=15.minutes
    end
  end

  describe 'Event#final_datetime_for_collection for repeating event with ends_on' do
    before do
      @event = FactoryGirl.build_stubbed(Event,
                                         name: 'Spec Scrum ends',
                                         start_datetime: '2014-03-07 10:30:00 UTC',
                                         repeats: 'weekly',
                                         repeats_every_n_weeks: 1,
                                         repeats_weekly_each_days_of_the_week_mask: 0b1111111,
                                         repeat_ends: true,
                                         repeat_ends_on: '2015-6-25')
    end

    it 'should return the repeat_ends_on datetime if that comes first' do
      Delorean.time_travel_to(Time.parse('2015-06-23 09:27:00 UTC'))
      options = {end_time: '2015-06-30 09:27:00 UTC'}
      expect(@event.final_datetime_for_collection(options)).to eq(@event.repeat_ends_on.to_datetime)
    end

    it 'should return the options[:endtime] if that comes before repeat_ends_on' do
      Delorean.time_travel_to(Time.parse('2015-06-15 09:27:00 UTC'))
      options = {end_time: '2015-06-20 09:27:00 UTC'}
      expect(@event.final_datetime_for_collection(options)).to eq(options[:end_time].to_datetime)
    end

    it 'should return the repeat_ends_on datetime if there is no options[end_time] and the ends_on datetime is less than 10 days away' do
      Delorean.time_travel_to(Time.parse('2015-06-23 09:27:00 UTC'))
      expect(@event.final_datetime_for_collection).to eq(@event.repeat_ends_on.to_datetime)
    end
  end

  describe 'Event#final_datetime_for_display for never-ending event' do
    before do
      @event = FactoryGirl.build_stubbed(Event,
                                         name: 'Spec Scrum never-ending',
                                         start_datetime: '2014-03-07 10:30:00 UTC',
                                         repeats: 'weekly',
                                         repeats_every_n_weeks: 1,
                                         repeats_weekly_each_days_of_the_week_mask: 0b1111111,
                                         repeat_ends: false)
    end

    it 'should return the options[:endtime] when specified' do
      Delorean.time_travel_to(Time.parse('2015-06-15 09:27:00 UTC'))
      options = {end_time: '2015-06-20 09:27:00 UTC'}
      expect(@event.final_datetime_for_collection(options)).to eq(options[:end_time].to_datetime)
    end

    it 'should return 10 days from now if there is no options[end_time]' do
      Delorean.time_travel_to(Time.parse('2015-06-23 09:27:00 UTC'))
      Event.collection_time_future= 10.days # 10 days is the default
      expect(@event.final_datetime_for_collection().to_datetime.to_s).to eq(10.days.from_now.to_datetime.to_s)
    end

    it 'should return 3 days from now if there is no options[end_time] and COLLECTION_TIME_FUTURE is 3.days instead of 10.days' do
      Delorean.time_travel_to(Time.parse('2015-06-23 09:27:00 UTC'))
      Event.collection_time_future= 3.days
      expect(@event.final_datetime_for_collection().to_datetime.to_s).to eq(3.days.from_now.to_datetime.to_s)
      Event.collection_time_future= 10.days # 10 days is the default
    end
  end

  describe 'Event.next_event_occurence' do
    @event = FactoryGirl.build(Event,
                               name: 'Spec Scrum one-time',
                               start_datetime: '2014-03-07 10:30:00 UTC',
                               duration: 30,
                               repeats: 'never'
    )

    it 'should return the next event occurence' do
      Delorean.time_travel_to(Time.parse('2014-03-07 09:27:00 UTC'))
      expect(Event.next_event_occurrence).to eq @event
    end

    it 'should return events that were schedule 15 minutes earlier or less' do
      Event.collection_time_past=15.minutes #15 minutes is the default
      Delorean.time_travel_to(Time.parse('2014-03-07 10:44:59 UTC'))
      expect(Event.next_event_occurrence).to eq @event
    end

    it 'should not return events that were scheduled to start more than 15 minutes ago' do
      Event.collection_time_past=15.minutes #15 minutes is the default
      Delorean.time_travel_to(Time.parse('2014-03-07 10:45:01 UTC'))
      expect(Event.next_event_occurrence).to be_nil
    end

    it 'should return events that were schedule 30 minutes earlier or less if we change collection_time_past to 30.minutes' do
      Event.collection_time_past=30.minutes #15 minutes is the default
      Delorean.time_travel_to(Time.parse('2014-03-07 10:59:59 UTC'))
      expect(Event.next_event_occurrence).to eq @event
      Event.collection_time_past=15.minutes #15 minutes is the default
    end
  end
end
