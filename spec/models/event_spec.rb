require 'spec_helper'
require 'user'

describe Event, :type => :model do
  before(:each) do
    ENV['TZ'] = 'UTC'
  end

  after(:each) do
    Delorean.back_to_the_present
  end

  subject(:event) { build_stubbed :event }

  it { is_expected.to respond_to :project_id }
  it { is_expected.to respond_to :friendly_id }
  it { is_expected.to respond_to :schedule }
  it { is_expected.to respond_to :live? }
  it { should belong_to :creator }

  it 'is valid with all the correct parameters' do
    expect(subject).to be_valid
  end

  it 'is invalid without name' do
    expect(FactoryBot.build(:event, name: nil)).to_not be_valid
  end

  it 'is invalid without category' do
    expect(FactoryBot.build(:event, category: nil)).to_not be_valid
  end

  it 'is invalid without repeats' do
    expect(FactoryBot.build(:event, repeats: nil)).to_not be_valid
  end

  it 'is invalid with invalid url' do
    expect(FactoryBot.build(:event, url: 'http:google.com')).to_not be_valid
  end

  describe "#less_than_ten_till_start?" do

    before(:each) { Delorean.time_travel_to '2014-03-16 23:30:00 UTC' }

    context 'event starts five minutes from now' do
      subject(:event) { build_stubbed :event, start_datetime: '2014-03-07 23:35:00 UTC' }
      it 'returns true' do
        expect(event).to be_less_than_ten_till_start
      end
    end

    context 'event starts 20 minutes from now' do
      subject(:event) { build_stubbed :event, start_datetime: '2014-03-07 23:50:00 UTC' }
      it 'returns false' do
        expect(event).not_to be_less_than_ten_till_start
      end
    end

    context 'event started five minutes ago and has not ended' do
      subject(:event) { build_stubbed :event, start_datetime: '2014-03-07 23:25:00 UTC' , duration: '10'}
      it 'returns true' do
        expect(event).to be_less_than_ten_till_start
      end
    end

    context 'event finished 10 minutes ago' do
      subject(:event) { build_stubbed :event, start_datetime: '2014-03-16 23:10:00 UTC', duration: '10' }
      it 'returns false' do
        expect(event).not_to be_less_than_ten_till_start
      end
    end

    context 'event sequence has been terminated' do
      subject(:event) { build_stubbed :event, start_datetime: '2014-03-07 23:50:00 UTC', repeat_ends_on: '2014-03-10' }
      it 'returns false' do
        expect(event).not_to be_less_than_ten_till_start
      end
    end
  end

  describe '#last_hangout' do
    it 'returns the latest hangout' do
      hangout1 = subject.event_instances.create
      hangout2 = subject.event_instances.create(created_at: Date.yesterday, updated_at: Date.yesterday)

      expect(subject.last_hangout).to eq(hangout1)
    end
  end

  context 'can remove event instance' do
    before(:each) do
      @event = FactoryBot.build(:event,
                                 name: 'Spec Scrum',
                                 start_datetime: 'Mon, 17 Jun 2013 09:00:00 UTC',
                                 duration: 30,
                                 repeats: 'weekly',
                                 repeats_every_n_weeks: 1,
                                 repeats_weekly_each_days_of_the_week_mask: 0b1100000,
                                 repeat_ends: true,
                                 repeat_ends_on: '2014-03-08')
    end

    it 'should remove an event instance when requested and date found' do
      Delorean.time_travel_to(Time.parse('2013-06-16 09:27:00 UTC'))
      @event.remove_from_schedule(Time.parse('2013-6-23 09:00:00 UTC'))
      expect(@event.schedule.first(4)).to eq(['Sat, 22 Jun 2013 09:00:00 UTC +00:00', 'Sat, 29 Jun 2013 09:00:00 UTC +00:00', 'Sun, 30 Jun 2013 09:00:00 UTC +00:00', 'Sat, 06 Jul 2013 09:00:00 UTC +00:00'])
    end

    it 'should move the start date forward when the event instance to be removed is the first in the series' do
      Delorean.time_travel_to(Time.parse('2013-06-16 09:27:00 UTC'))
      @event.remove_from_schedule(Time.parse('2013-6-22 09:00:00 UTC'))
      expect(@event.start_datetime).to eq('Sun, 23 Jun 2013 09:00:00 UTC +00:00')
      expect(@event.schedule.first(4)).to eq(['Sun, 23 Jun 2013 09:00:00 UTC +00:00', 'Sat, 29 Jun 2013 09:00:00 UTC +00:00', 'Sun, 30 Jun 2013 09:00:00 UTC +00:00', 'Sat, 06 Jul 2013 09:00:00 UTC +00:00'])
    end

    it 'event exclusions should be persistent' do
      Delorean.time_travel_to(Time.parse('2013-06-16 09:27:00 UTC'))
      @event.remove_from_schedule(Time.parse('2013-6-23 09:00:00 UTC'))
      event = Event.find_by(name: 'Spec Scrum')
      expect(event.schedule.first(4)).to eq(['Sat, 22 Jun 2013 09:00:00 UTC +00:00', 'Sat, 29 Jun 2013 09:00:00 UTC +00:00', 'Sun, 30 Jun 2013 09:00:00 UTC +00:00', 'Sat, 06 Jul 2013 09:00:00 UTC +00:00'])
    end
  end


  context 'should create a scrum event that ' do
    it 'is scheduled for one occasion' do
      event = FactoryBot.build_stubbed(:event,
                                        name: 'one time event',
                                        category: 'Scrum',
                                        description: '',
                                        start_datetime: 'Mon, 17 Jun 2013 09:00:00 UTC',
                                        duration: 600,
                                        repeats: 'never',
                                        repeats_every_n_weeks: nil,
                                        repeat_ends_string: 'on',
                                        repeat_ends: true,
                                        repeat_ends_on: 'Mon, 17 Jun 2013',
                                        time_zone: 'Eastern Time (US & Canada)')
      expect(event.schedule.first(5)).to eq(['Mon, 17 Jun 2013 09:00:00 UTC +00:00'])
    end

    it 'is scheduled for every weekend' do
      event = FactoryBot.build_stubbed(:event,
                                        name: 'every weekend event',
                                        category: 'Scrum',
                                        description: '',
                                        start_datetime: 'Mon, 17 Jun 2013 09:00:00 UTC',
                                        duration: 600,
                                        repeats: 'weekly',
                                        repeats_every_n_weeks: 1,
                                        repeats_weekly_each_days_of_the_week_mask: 96,
                                        repeat_ends: false,
                                        repeat_ends_on: 'Tue, 25 Jun 2013',
                                        time_zone: 'Eastern Time (US & Canada)')
      expect(event.schedule.first(5)).to eq(['Sat, 22 Jun 2013 09:00:00 UTC +00:00', 'Sun, 23 Jun 2013 09:00:00 UTC +00:00', 'Sat, 29 Jun 2013 09:00:00 UTC +00:00', 'Sun, 30 Jun 2013 09:00:00 UTC +00:00', 'Sat, 06 Jul 2013 09:00:00 UTC +00:00'])
    end

    it 'is scheduled for every Sunday' do
      event = FactoryBot.build_stubbed(:event,
                                        name: 'every Sunday event',
                                        category: 'Scrum',
                                        description: '',
                                        start_datetime: 'Mon, 17 Jun 2013 09:00:00 UTC',
                                        duration: 600,
                                        repeats: 'weekly',
                                        repeats_every_n_weeks: 1,
                                        repeats_weekly_each_days_of_the_week_mask: 64,
                                        repeat_ends: false,
                                        repeat_ends_on: 'Mon, 17 Jun 2013',
                                        time_zone: 'Eastern Time (US & Canada)')
      expect(event.schedule.first(5)).to eq(['Sun, 23 Jun 2013 09:00:00 UTC +00:00', 'Sun, 30 Jun 2013 09:00:00 UTC +00:00', 'Sun, 07 Jul 2013 09:00:00 UTC +00:00', 'Sun, 14 Jul 2013 09:00:00 UTC +00:00', 'Sun, 21 Jul 2013 09:00:00 UTC +00:00'])
    end

    it 'is scheduled for every Monday' do
      event = FactoryBot.build_stubbed(:event,
                                        name: 'every Monday event',
                                        category: 'Scrum',
                                        description: '',
                                        start_datetime: 'Mon, 17 Jun 2013 09:00:00 UTC',
                                        duration: 600,
                                        repeats: 'weekly',
                                        repeats_every_n_weeks: 1,
                                        repeats_weekly_each_days_of_the_week_mask: 1,
                                        repeat_ends: false,
                                        repeat_ends_on: 'Mon, 17 Jun 2013',
                                        time_zone: 'UTC')
      expect(event.schedule.first(5)).to eq(['Mon, 17 Jun 2013 09:00:00 GMT +00:00', 'Mon, 24 Jun 2013 09:00:00 GMT +00:00', 'Mon, 01 Jul 2013 09:00:00 GMT +00:00', 'Mon, 08 Jul 2013 09:00:00 GMT +00:00', 'Mon, 15 Jul 2013 09:00:00 GMT +00:00'])
    end
  end

  context 'should create a hookup event that' do
    before do
      @event = FactoryBot.build_stubbed(:event,
                                         name: 'PP Monday event',
                                         category: 'PairProgramming',
                                         start_datetime: 'Mon, 17 Jun 2014 09:00:00 UTC',
                                         duration: 90,
                                         repeats: 'never',
                                         time_zone: 'UTC')
    end

    it 'should expire events that ended' do
      hangout = @event.event_instances.create(hangout_url: 'anything@anything.com',
                                              updated_at: '2014-06-17 10:25:00 UTC')
      allow(hangout).to receive(:started?).and_return(true)
      Delorean.time_travel_to(Time.parse('2014-06-17 10:31:00 UTC'))
      expect(@event).to_not be_live
    end

    it 'should mark as active events which have started and have not ended' do
      hangout = @event.event_instances.create(hangout_url: 'anything@anything.com',
                                              updated_at: '2014-06-17 10:25:00 UTC')
      Delorean.time_travel_to(Time.parse('2014-06-17 10:26:00 UTC'))
      expect(@event).to be_live
    end

    it 'should not be started if events have not started' do
      hangout = @event.event_instances.create(hangout_url: nil,
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
                repeat_ends: false,
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

  describe '#next_event_occurrence_with_time' do
    before(:each) do
      @event = FactoryBot.build(:event,
                                 name: 'Spec Scrum',
                                 start_datetime: 'Mon, 10 Jun 2013 09:00:00 UTC',
                                 duration: 30,
                                 repeats: 'weekly',
                                 repeats_every_n_weeks: 1,
                                 repeats_weekly_each_days_of_the_week_mask: 0b1000000,
                                 repeat_ends: true,
                                 repeat_ends_on: '2013-07-01')
    end

    it 'should return the first event instance with its time in basic case' do
      Delorean.time_travel_to(Time.parse('2013-06-15 09:27:00 UTC'))
      expect(@event.next_event_occurrence_with_time[:time]).to eq('2013-06-16 09:00:00 UTC')
    end

    it 'should return nil if the series has expired' do
      Delorean.time_travel_to(Time.parse('2013-07-15 09:27:00 UTC'))
      expect(@event.next_event_occurrence_with_time).to be_nil
    end

    it 'should return the second event instance when the start time is moved forward' do
      Delorean.time_travel_to(Time.parse('2013-06-20 09:27:00 UTC'))
      expect(@event.next_event_occurrence_with_time[:time]).to eq('2013-06-23 09:00:00 UTC')
    end

    it 'should return the second event instance with its time when the first is deleted' do
      Delorean.time_travel_to(Time.parse('2013-06-15 09:27:00 UTC'))
      @event.remove_from_schedule(Time.parse('2013-6-16 09:00:00 UTC'))
      expect(@event.next_event_occurrence_with_time[:time]).to eq('2013-06-23 09:00:00 UTC')
    end

    it 'should return the event instance when it is not recurring and the event occurs in the future' do
      @event.update_attribute(:repeats, 'never')
      Delorean.time_travel_to(Time.parse('2013-06-05 09:27:00 UTC'))
      expect(@event.next_event_occurrence_with_time[:time]).to eq('2013-06-10 09:00:00 UTC')
    end

    it 'should not return the event instance when it is not recurring' do
      @event.update_attribute(:repeats, 'never')
      Delorean.time_travel_to(Time.parse('2013-06-15 09:27:00 UTC'))
      expect(@event.next_event_occurrence_with_time).to be_nil
    end
  end

  describe '#next_occurences' do
    before do
      @event = FactoryBot.build_stubbed(:event,
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
      expect(@event.next_occurrence_time_method(15.minutes.ago)).to eq(Time.parse('2014-03-07 10:30:00 UTC'))
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
          options = {limit: 2}
          Delorean.time_travel_to(Time.parse('2014-03-08 09:27:00 UTC'))
          expect(@event.next_occurrences(options).count).to eq(2)
        end
      end

      context ':start_time option' do
        it 'should return only occurrences after a specific time' do
          start_time = Time.parse('2014-03-09 9:27:00 UTC')
          Delorean.time_travel_to(Time.parse('2014-03-05 09:27:00 UTC'))
          expect(@event.next_occurrence_time_method(start_time)).to eq(Time.parse('2014-03-09 10:30:00 UTC'))
        end
      end
    end
  end

  describe 'Event#start_datetime_for_collection for starting event' do
    before do
      @event = FactoryBot.build_stubbed(:event,
                                         name: 'Spec Scrum never ends',
                                         start_datetime: '2014-03-07 10:30:00 UTC',
                                         duration: 30)
    end

    it 'should return the start_time if it is specified' do
      Delorean.time_travel_to(Time.parse('2015-06-23 09:27:00 UTC'))
      options = {start_time: '2015-06-20 09:27:00 UTC'}
      expect(@event.start_datetime_for_collection(options)).to eq(options[:start_time])
    end
  end

  describe 'Event#final_datetime_for_collection for repeating event with ends_on' do
    before do
      @event = FactoryBot.build_stubbed(:event,
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
      @event = FactoryBot.build_stubbed(:event,
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
      # 10 days is the default
      expect(@event.final_datetime_for_collection().to_datetime.to_s).to eq(10.days.from_now.to_datetime.to_s)
    end
  end

  describe 'Event.next_event_occurence' do
    @event = FactoryBot.build(:event,
                               category: 'Scrum',
                               name: 'Spec Scrum one-time',
                               start_datetime: '2014-03-07 10:30:00 UTC',
                               duration: 30,
                               repeats: 'never'
    )

    it 'should return the next event occurence' do
      Delorean.time_travel_to(Time.parse('2014-03-07 09:27:00 UTC'))
      expect(Event.next_occurrence(:scrum)).to eq @event
    end

    it 'should return events that were schedule 15 minutes earlier or less' do
      #15 minutes is the default for COLLECTION_TIME_PAST
      Delorean.time_travel_to(Time.parse('2014-03-07 10:44:59 UTC'))
      expect(Event.next_occurrence(:scrum)).to eq @event
    end

    it 'should not return events that were scheduled to start more than 15 minutes ago' do
      Delorean.time_travel_to(Time.parse('2014-03-07 10:45:01 UTC'))
      expect(Event.next_occurrence(:scrum)).to be_nil
    end

    it 'should return events that were schedule 30 minutes earlier or less if we change collection_time_past to 30.minutes' do
      Delorean.time_travel_to(Time.parse('2014-03-07 10:59:59 UTC'))
      expect(Event.next_occurrence(:scrum, 30.minutes.ago)).to eq @event
    end
  end

  describe '#recent_hangouts' do
    before(:each) do
      event.event_instances.create(created_at: Date.yesterday, updated_at: Date.yesterday + 15.minutes)
      @recent_hangout = event.event_instances.create(created_at: 1.second.ago, updated_at: 1.second.ago)
    end

    it 'returns only the hangouts updated between yesterday and today' do
      expect(event.recent_hangouts.to_a).to match_array([@recent_hangout])
    end
  end

  describe '#upcoming_events' do
    before(:each) do
      @event1 = FactoryBot.create(:event,
                                 category: 'Scrum',
                                 name: 'Spec Scrum one-time',
                                 start_datetime: '2015-06-15 09:20:00 UTC',
                                 duration: 30,
                                 repeats: 'never'
      )
      @event2 = FactoryBot.create(:event,
                                 category: 'Scrum',
                                 name: 'Spec Scrum one-time',
                                 start_datetime: '2015-06-15 09:25:00 UTC',
                                 duration: 30,
                                 repeats: 'never'
      )
    end

    it 'shows future events' do
      Delorean.time_travel_to(Time.parse('2015-06-15 09:25:00 UTC'))
      expect(Event.upcoming_events.count).to eq(2)
    end

    it 'does not show finished events' do
      Delorean.time_travel_to(Time.parse('2015-06-15 09:51:00 UTC'))
      expect(Event.upcoming_events.count).to eq(1)
    end

    it 'returns event 1 minute before ending' do
      Delorean.time_travel_to(Time.parse('2015-06-15 09:54:00 UTC'))
      expect(Event.upcoming_events.count).to eq(1)
    end

    it 'does not return event 1 minute after ending' do
      Delorean.time_travel_to(Time.parse('2015-06-15 09:56:00 UTC'))
      expect(Event.upcoming_events.count).to eq(0)
    end

    it 'returns event past event duration, but still live' do
      event_instance = FactoryBot.create(:event_instance)
      event_end_time = event_instance.event.start_datetime + event_instance.event.duration.minutes
      expect(event_end_time).to be < Time.current
      expect(event_instance.event).to eq(Event.upcoming_events.last[:event])
    end

  end

  context 'modifier' do
    it 'responds to modifier' do
      @event = FactoryBot.build(:event,
                                 name: 'Spec Scrum',
                                 modifier_id: 1)
      expect(User).to receive(:find).with(1)
      @event.modifier
    end
  end

  context '#jitsi_room_link' do
    it 'returns correct link' do
      event = FactoryBot.build(:event, name: 'Repeat Scrum-~!@#$')
      expect(event.jitsi_room_link).to eq('https://meet.jit.si/AV_Repeat_Scrum')
    end
  end
end
