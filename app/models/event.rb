class Event < ApplicationRecord
  has_many :event_instances
  belongs_to :project
  serialize :exclusions

  belongs_to :creator, class_name: 'User'

  extend FriendlyId
  friendly_id :name, use: :slugged

  include IceCube
  validates :name, :time_zone, :repeats, :category, :start_datetime, :duration, presence: true
  validates :url, uri: true, :allow_blank => true
  validates :repeats_every_n_weeks, :presence => true, :if => lambda { |e| e.repeats == 'weekly' or e.repeats == 'biweekly' }
  validates :repeat_ends_on, :presence => true, :allow_blank => false, :if => lambda{ |e| (e.repeats == 'weekly' or e.repeats == 'biweekly') and e.repeat_ends_string == 'on' }
  validate :must_have_at_least_one_repeats_weekly_each_days_of_the_week, :if => lambda { |e| e.repeats == 'weekly' or e.repeats == 'biweekly' }
  attr_accessor :next_occurrence_time_attr
  attr_accessor :repeat_ends_string

  COLLECTION_TIME_FUTURE = 10.days
  COLLECTION_TIME_PAST = 300.minutes
  NEXT_SCRUM_COLLECTION_TIME_PAST = 15.minutes

  REPEATS_OPTIONS = %w[never weekly biweekly]
  REPEAT_ENDS_OPTIONS = %w[on never]
  DAYS_OF_THE_WEEK = %w[monday tuesday wednesday thursday friday saturday sunday]

  # hoped the below would help address the issue about how rails 4 -> 5 is going to treat setting non-booleans
  # to booleans - adding the setter fixes the specs, but breaks the acceptance tests
  #
  # def repeat_ends=(repeat_ends)
  #   super repeat_ends == 'on'
  # end
  #
  # def repeat_ends
  #   super ? 'on' : 'never'
  # end

  def set_repeat_ends_string
    @repeat_ends_string = repeat_ends ? 'on' : 'never'
  end

  def self.base_future_events(project)
    project.nil? ? Event.future_events : Event.future_events.where(project_id: project)
  end

  def self.future_events
    Event.where('repeats = \'never\' OR repeat_ends = false OR repeat_ends IS NULL OR repeat_ends_on > ?', Time.now)
  end

  def self.upcoming_events(project=nil)
    events = Event.base_future_events(project).inject([]) do |memo, event|
      memo << event.next_occurrences
    end.flatten.sort_by { |e| e[:time] }
    Event.remove_past_events(events)
  end

  def self.remove_past_events(events)
    events.delete_if {|event| (event[:time] + event[:event].duration.minutes) < Time.current &&
                            !event[:event].event_instances.last.try(:live?)}
  end

  def self.hookups
    Event.where(category: "PairProgramming")
  end

  def self.pending_hookups
    pending = []
    hookups.each do |h|
      started = h.last_hangout && h.last_hangout.started?
      expired_without_starting = !h.last_hangout && Time.now.utc > h.instance_end_time
      pending << h if !started && !expired_without_starting
    end
    pending
  end

  def event_date
    start_datetime
  end

  def start_time
    start_datetime
  end

  def series_end_time
    repeat_ends && repeat_ends_on.present? ? repeat_ends_on.to_time : nil
  end

  def instance_end_time
    (start_datetime + duration*60).utc
  end

  def end_date
    if (series_end_time < start_time)
      (event_date.to_datetime + 1.day).strftime('%Y-%m-%d')
    else
      event_date
    end
  end

  def live?
    last_hangout.present? && last_hangout.live?
  end

  def final_datetime_for_collection(options = {})
    if repeating_and_ends? && options[:end_time].present?
      final_datetime = [options[:end_time], repeat_ends_on.to_datetime].min
    elsif repeating_and_ends?
      final_datetime = repeat_ends_on.to_datetime
    else
      final_datetime = options[:end_time]
    end
    final_datetime ? final_datetime.to_datetime.utc : COLLECTION_TIME_FUTURE.from_now
  end

  def start_datetime_for_collection(options = {})
    first_datetime = options.fetch(:start_time, COLLECTION_TIME_PAST.ago)
    first_datetime = [start_datetime, first_datetime.to_datetime].max
    first_datetime.to_datetime.utc
  end

  def next_occurrence_time_method(start = Time.now)
    next_occurrence = next_event_occurrence_with_time(start)
    next_occurrence.present? ? next_occurrence[:time] : nil
  end

  def self.next_occurrence(event_type, begin_time = NEXT_SCRUM_COLLECTION_TIME_PAST.ago)
    events_with_times = []
    events_with_times = Event.where(category: event_type).map { |event|
      event.next_event_occurrence_with_time(begin_time)
    }.compact
    return nil if events_with_times.empty?
    events_with_times = events_with_times.sort_by { |e| e[:time] }
    events_with_times[0][:event].next_occurrence_time_attr = events_with_times[0][:time]
    return events_with_times[0][:event]
  end

  # The IceCube Schedule's occurrences_between method requires a time range as input to find the next time
  # Most of the time, the next instance will be within the next weeek.do
  # But some event instances may have been excluded, so there's not guarantee that the next time for an event will be within the next week, or even the next month
  # To cover these cases, the while loop looks farther and farther into the future for the next event occurrence, just in case there are many exclusions.
  def next_event_occurrence_with_time(start = Time.now, final= 2.months.from_now)
    begin_datetime = start_datetime_for_collection(start_time: start)
    final_datetime = repeating_and_ends? ? repeat_ends_on : final
    n_days = 8
    end_datetime = n_days.days.from_now
    event = nil
    return next_event_occurrence_with_time_inner(start, final_datetime) if self.repeats == 'never'
    while event.nil? && end_datetime < final_datetime
      event = next_event_occurrence_with_time_inner(start, final_datetime)
      n_days *= 2
      end_datetime = n_days.days.from_now
    end
    event
  end

  def next_event_occurrence_with_time_inner(start_time, end_time)
    occurrences = occurrences_between(start_time, end_time)
    { event: self, time: occurrences.first.start_time } if occurrences.present?
  end

  def next_occurrences(options = {})
    begin_datetime = start_datetime_for_collection(options)
    final_datetime = final_datetime_for_collection(options)
    limit = options.fetch(:limit, 100)
    [].tap do |occurences|
      occurrences_between(begin_datetime, final_datetime).each do |time|
        occurences << { event: self, time: time }
        return occurences if occurences.count >= limit
      end
    end
  end

  def occurrences_between(start_time, end_time)
    schedule.occurrences_between(start_time.to_time, end_time.to_time)
  end

  def repeats_weekly_each_days_of_the_week=(repeats_weekly_each_days_of_the_week)
    self.repeats_weekly_each_days_of_the_week_mask = (repeats_weekly_each_days_of_the_week & DAYS_OF_THE_WEEK).map { |r| 2**DAYS_OF_THE_WEEK.index(r) }.inject(0, :+)
  end

  def repeats_weekly_each_days_of_the_week
    DAYS_OF_THE_WEEK.reject do |r|
      ((repeats_weekly_each_days_of_the_week_mask || 0) & 2**DAYS_OF_THE_WEEK.index(r)).zero?
    end
  end

  def remove_from_schedule(timedate)
    # best if schedule is serialized into the events record...  and an attribute.
    if timedate >= Time.now && timedate == next_occurrence_time_method
      _next_occurrences = next_occurrences(limit: 2)
      self.start_datetime = (_next_occurrences.size > 1) ? _next_occurrences[1][:time] : timedate + 1.day
    elsif timedate >= Time.now
      self.exclusions ||= []
      self.exclusions << timedate
    end
    save!
  end

  def schedule()
    sched = series_end_time.nil? || !repeat_ends ? IceCube::Schedule.new(start_datetime) : IceCube::Schedule.new(start_datetime, :end_time => series_end_time)
    case repeats
      when 'never'
        sched.add_recurrence_time(start_datetime)
      when 'weekly', 'biweekly'
        days = repeats_weekly_each_days_of_the_week.map { |d| d.to_sym }
        sched.add_recurrence_rule IceCube::Rule.weekly(repeats_every_n_weeks).day(*days)
    end
    self.exclusions ||= []
    self.exclusions.each do |ex|
      sched.add_exception_time(ex)
    end
    sched
  end

  def start_time_with_timezone
    DateTime.parse(start_time.strftime('%k:%M ')).in_time_zone(time_zone)
  end

  def last_hangout
    event_instances.order(:created_at).last
  end

  def recent_hangouts
    event_instances
      .where('created_at BETWEEN ? AND ?', 1.days.ago + duration.minutes, DateTime.now.end_of_day)
      .order(created_at: :desc)
  end

  def less_than_ten_till_start?
    return true if within_current_event_duration?
    Time.now > next_event_occurrence_with_time[:time] - 10.minutes
  rescue
    false
  end

  def within_current_event_duration?
    after_current_start_time? and before_current_end_time?
  end

  def current_start_time
    schedule.previous_occurrence(Time.now)
  end

  def current_end_time
    schedule.previous_occurrence(Time.now) + duration*60
  end

  def before_current_end_time?
    Time.now < current_end_time
  rescue
    false
  end

  def after_current_start_time?
    Time.now > current_start_time
  rescue
    false
  end

  def jitsi_room_link
    "https://meet.jit.si/AV_#{name.tr(' ', '_').gsub(/[^0-9a-zA-Z_]/i, '')}"
  end

  def modifier
    User.find modifier_id
  end

  private

  def must_have_at_least_one_repeats_weekly_each_days_of_the_week
    if repeats_weekly_each_days_of_the_week.empty?
      errors.add(:base, 'You must have at least one repeats weekly each days of the week')
    end
  end

  def repeating_and_ends?
    repeats != 'never' && repeat_ends && !repeat_ends_on.blank?
  end
end
