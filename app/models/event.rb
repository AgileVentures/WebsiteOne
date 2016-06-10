require 'forwardable'

class Event < ActiveRecord::Base
  has_many :event_instances
  belongs_to :project
  serialize :exclusions

  # class methods delegation 
  extend SingleForwardable
  def_delegators :OccurrenceManager, :next_occurrence

  # instance methods delegation
  extend Forwardable
  delegate [:next_event_occurrence_with_time] => :occurrence_manager

  extend FriendlyId
  friendly_id :name, use: :slugged

  include IceCube
  validates :name, :time_zone, :repeats, :category, :start_datetime, :duration, presence: true
  validates :url, uri: true, :allow_blank => true
  validates :repeats_every_n_weeks, :presence => true, :if => lambda { |e| e.repeats == 'weekly' }
  validates :repeat_ends_on, :presence => true, :allow_blank => false, :if => lambda{ |e| e.repeats == 'weekly' and e.repeat_ends_string == 'on'}
  validate :must_have_at_least_one_repeats_weekly_each_days_of_the_week, :if => lambda { |e| e.repeats == 'weekly' }
  attr_accessor :next_occurrence_time_attr
  attr_accessor :repeat_ends_string

  COLLECTION_TIME_FUTURE    = 10.days
  COLLECTION_TIME_PAST      = 15.minutes

  REPEATS_OPTIONS           = %w[never weekly]
  REPEAT_ENDS_OPTIONS       = %w[on never]
  DAYS_OF_THE_WEEK          = %w[monday tuesday wednesday thursday friday saturday sunday]

  scope :hookups, -> { where(category: "PairProgramming") }

  # CLASS METHODS BEGIN
  def self.pending_hookups
    hookups.select {|hookup| hookup.pending? } 
  end

  def next_occurrence_time_method(start = Time.now)
    next_occurrence         = next_event_occurrence_with_time(start)
    next_occurrence.time    if next_occurrence.present?
  end

  def occurrence_manager
    @occurrence_manager = OccurrenceManager.new(self)
  end

  # Event#next_event_occurrence_with_time BEGIN
=begin
  # The IceCube Schedule's occurrences_between method requires a time range as input to find the next time
  # Most of the time, the next instance will be within the next weeek.
  # But some event instances may have been excluded, so there's not guarantee 
  # that the next time for an event will be within the next week, or even the next month
  # To cover these cases, the while loop looks farther and farther into the future 
  # for the next event occurrence, just in case there are many exclusions.
  def next_event_occurrence_with_time(start_time = Time.now, final_time=2.months.from_now)
    begin_datetime    = start_datetime_for_collection(start_time: start_time)
    final_datetime    = repeating_and_ends? ? repeat_ends_on : final_time

    return closest_event(start_time, final_datetime)    if     repeats == 'never'
    return distant_event(start_time, final_datetime)    unless repeats == 'never'
  end

  def closest_event(start_time, end_time)
    next_occurrence_with_time(start_time, end_time)
  end

  def distant_event(start_time, end_time)
    event         = nil
    n_days        = 8
    end_datetime  = n_days.days.from_now
    
    while end_datetime < end_time
      break unless event.nil?
      event         = next_occurrence_with_time(start_time, end_time)
      n_days        *= 2
      end_datetime  = n_days.days.from_now
    end
    event
  end

  def next_occurrence_with_time(start_time, end_time)
    occurrences = occurrences_between(start_time, end_time)
    EventOccurrence.new(self, occurrences.first.start_time)  if occurrences.present?
  end
    
  # Event#next_event_occurrence_with_time END

  def next_occurrence_with_time(start_time, end_time)
    occurrences = occurrences_between(start_time, end_time)
    EventOccurrence.new(self, occurrences.first.start_time)  if occurrences.present?
  end
=end

  def all_occurrences_for(start_time, end_time, limit, &block)
    occurrences_between(start_time, end_time).each_with_index do |time, index|
      block.call({ event: self, time: time })
      break if index + 1 >= limit
    end
  end

  # NEXT OCCURRENCES RELATED BEGIN
  def start_datetime_for_collection(options = {})
    start_time    = options.fetch(:start_time, COLLECTION_TIME_PAST.ago)
    lower_bound   = [start_datetime, start_time.to_datetime].max
    lower_bound.to_datetime.utc
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

  def next_occurrences(options = {})
    begin_datetime    = start_datetime_for_collection(options)
    final_datetime    = final_datetime_for_collection(options)
    limit             = options.fetch(:limit, 100)
    result            = []
    
    all_occurrences_for(begin_datetime, final_datetime, limit) {|evt| result << evt }
    result
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
  # NEXT OCCURRENCES RELATED END

  # ABSTRACTION ABOVE 'SCHEDULE' BEGIN
  def occurrences_between(start_time, end_time)
    schedule.occurrences_between(start_time.to_time, end_time.to_time)
  end
  # ABSTRACTION ABOVE 'SCHEDULE' END

  # HELPERS BEGIN 
  def repeats_weekly_each_days_of_the_week=(repeats_weekly_each_days_of_the_week)
    result = (repeats_weekly_each_days_of_the_week & DAYS_OF_THE_WEEK).map { |r| 2**DAYS_OF_THE_WEEK.index(r) }.inject(0, :+)
    self.repeats_weekly_each_days_of_the_week_mask = result
  end

  def repeats_weekly_each_days_of_the_week
    DAYS_OF_THE_WEEK.reject do |r|
      ((repeats_weekly_each_days_of_the_week_mask || 0) & 2**DAYS_OF_THE_WEEK.index(r)).zero?
    end
  end
  # HELPERS END

  # SCHEDULE SETUP BEGIN
  def schedule
    create_schedule
    define_repeats
    add_exclusions_to_schedule
  end

  def create_schedule
    @schedule = Schedule.new(start_datetime)                                  unless repeat_ends
    @schedule = Schedule.new(start_datetime, :end_time => series_end_time)    if repeat_ends
  end

  def define_repeats
    @schedule.add_recurrence_time(start_datetime)     if repeats == 'never'
    add_recurrence_rules                              if repeats == 'weekly'
  end

  def add_recurrence_rules
    rule = Rule.weekly(repeats_every_n_weeks).day(*days_interval)
    @schedule.add_recurrence_rule rule
  end

  def add_exclusions_to_schedule
    self.exclusions ||= []
    self.exclusions.each do |ex|
      @schedule.add_exception_time(ex)
    end
    @schedule
  end

  def days_interval
    repeats_weekly_each_days_of_the_week.map { |d| d.to_sym }
  end
  # SCHEDULE SETUP END

  def start_time_with_timezone
    DateTime.parse(start_time.strftime('%k:%M ')).in_time_zone(time_zone)
  end

  def last_hangout
    event_instances.latest.first
  end

  def recent_hangouts
    event_instances.recent.latest
  end

  def pending?
    last_not_started? && not_expired_without_starting?
  end

  def last_started?
    last_hangout && last_hangout.started?
  end

  def not_expired_without_starting?
    not expired_without_starting?
  end

  def expired_without_starting?
    !last_hangout && expired?
  end

  def last_not_started?
    !last_started?
  end

  def start_time
    start_datetime
  end

  def series_end_time
    repeat_ends_on.to_time if repeats_end_present?
  end

  def instance_end_time
    (start_datetime + duration*60).utc
  end

  def end_date
    return next_day_from_start_time if (series_end_time < start_time)
    start_time
  end

  def live?
    last_hangout.present? && last_hangout.live?
  end

  def set_repeat_ends_string
    @repeat_ends_string = repeat_ends ? "on" : "never"
  end

  private
    def must_have_at_least_one_repeats_weekly_each_days_of_the_week
      if repeats_weekly_each_days_of_the_week.empty?
        errors.add(:base, 'You must have at least one repeats weekly each days of the week')
      end
    end

    def next_day_from_start_time
      (start_time.to_datetime + 1.day).strftime('%Y-%m-%d')
    end

    def repeating_and_ends?
      repeats != 'never' && repeat_ends && !repeat_ends_on.blank?
    end

    def expired?
      Time.now.utc > instance_end_time
    end

    def repeats_end_present?
      repeat_ends && repeat_ends_on.present? 
    end
end

EventOccurrence = Struct.new(:event, :time)

class OccurrenceManager
  extend Forwardable
  delegate [
    :next_occurrence_with_time, 
    :start_datetime,
    :repeating_and_ends?,
    :repeat_ends_on,
    :repeats,
    :occurrences_between
    ] => :@event

  COLLECTION_TIME_PAST = 15.minutes

  attr_reader :event
  def initialize(event)
    @event = event
  end

  def self.next_occurrence(event_type, begin_time = COLLECTION_TIME_PAST.ago)
    events_with_times = select_events_with_time(event_type: event_type, begin_time: begin_time)

    unless events_with_times.empty?
      events_with_times = events_with_times.sort {|e1, e2| e1.time <=> e2.time }
      events_with_times.first.event.next_occurrence_time_attr = events_with_times.first.time
      events_with_times.first.event
    end    
  end

  def self.select_events_with_time(args)
    event_type  = args.fetch(:event_type)
    begin_time  = args.fetch(:begin_time)

    find_category_next_occurences(event_type, begin_time)
  end

  def self.find_category_next_occurences(event_type, begin_time)
    Event.where(category: event_type).map do |event|
      event.next_event_occurrence_with_time(begin_time)
    end.compact
  end

  def next_event_occurrence_with_time(start_time = Time.now, final_time=2.months.from_now)
    begin_datetime    = start_datetime_for_collection(start_time: start_time)
    final_datetime    = repeating_and_ends? ? repeat_ends_on : final_time

    return closest_event(start_time, final_datetime)    if     repeats == 'never'
    return distant_event(start_time, final_datetime)    unless repeats == 'never'
  end

  def next_occurrence_with_time(start_time, end_time)
    occurrences = occurrences_between(start_time, end_time)
    EventOccurrence.new(event, occurrences.first.start_time)  if occurrences.present?
  end

  private 
    def start_datetime_for_collection(options = {})
      start_time    = options.fetch(:start_time, COLLECTION_TIME_PAST.ago)
      lower_bound   = [start_datetime, start_time.to_datetime].max
      lower_bound.to_datetime.utc
    end

    def closest_event(start_time, end_time)
      next_occurrence_with_time(start_time, end_time)
    end

    def distant_event(start_time, end_time)
      event         = nil
      n_days        = 8
      end_datetime  = n_days.days.from_now
      
      while end_datetime < end_time
        break unless event.nil?
        event         = next_occurrence_with_time(start_time, end_time)
        n_days        *= 2
        end_datetime  = n_days.days.from_now
      end
      event
    end
end

