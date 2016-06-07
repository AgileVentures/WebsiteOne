class Event < ActiveRecord::Base
  has_many    :event_instances
  belongs_to  :project
  serialize   :exclusions

  extend FriendlyId
  extend Forwardable
  friendly_id :name, use: :slugged

  delegate [ :occurrences_between,
             :next_event_occurrence_with_time,
             :next_occurrences,
             :start_datetime_for_collection,
             :final_datetime_for_collection,
             :remove_from_schedule,
             :next_occurrence_time_method
             ] => :schedule

  delegate [:next_occurrence, :select_events_with_time] => :Scheduler

  validates :name, :time_zone, :repeats, :category, :start_datetime, :duration, presence: true
  validates :url, uri: true, :allow_blank => true
  validates :repeats_every_n_weeks, :presence => true, :if => lambda { |e| e.repeats == 'weekly' }
  validates :repeat_ends_on, :presence => true, :allow_blank => false, :if => lambda{ |e| e.repeats == 'weekly' and e.repeat_ends_string == 'on'}
  validate  :must_have_at_least_one_repeats_weekly_each_days_of_the_week, :if => lambda { |e| e.repeats == 'weekly' }
  attr_accessor :next_occurrence_time_attr
  attr_accessor :repeat_ends_string

  COLLECTION_TIME_FUTURE    = 10.days
  COLLECTION_TIME_PAST      = 15.minutes

  REPEATS_OPTIONS           = %w[never weekly]
  REPEAT_ENDS_OPTIONS       = %w[on never]
  DAYS_OF_THE_WEEK          = %w[monday tuesday wednesday thursday friday saturday sunday]

  scope :hookups, -> { where(category: 'PairProgramming') }

  def set_repeat_ends_string
    @repeat_ends_string = repeat_ends ? "on" : "never"
  end

  def self.pending_hookups
    hookups.select {|hookup| hookup.pending? }
  end

  def self.next_occurrence(*args)
    EventScheduler.next_occurrence(*args)
  end

  # duplication!
  def event_date
    start_datetime
  end

  def start_time
    start_datetime
  end

  def repeats_weekly_each_days_of_the_week=(value)
    computed_value = (value & DAYS_OF_THE_WEEK).map do |r| 
      2 ** DAYS_OF_THE_WEEK.index(r) 
    end.inject(0, :+)

    self.repeats_weekly_each_days_of_the_week_mask = computed_value
  end

  def repeats_weekly_each_days_of_the_week
    DAYS_OF_THE_WEEK.reject do |r|
      ((repeats_weekly_each_days_of_the_week_mask || 0) & 2**DAYS_OF_THE_WEEK.index(r)).zero?
    end
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

  def start_time_with_timezone
    DateTime.parse(start_time.strftime('%k:%M ')).in_time_zone(time_zone)
  end

  def last_hangout
    event_instances.latest.first
  end

  def recent_hangouts
    event_instances.recent.latest
  end

  def expired?
    Time.now.utc > instance_end_time
  end

  def pending?
    not expired?
  end

  def expired_without_starting?
    last_hangout && expired?
  end

  def instance_end_time
    estimated_end_time = start_datetime + (duration * 60)
    estimated_end_time.utc
  end

  def schedule
    EventScheduler.new(self)
  end

  private

    def must_have_at_least_one_repeats_weekly_each_days_of_the_week
      msg = 'You must have at least one repeats weekly each days of the week'
      add_error_message(type: :base, msg: msg)  if schedule.repeats_weekly_each_days_of_the_week.empty?
    end

    def add_error_message(args)
      errors.add(args[:type], args[:msg])
    end

    def last_event_started?
      last_hangout && last_hangout.started?
    end

    def last_event_not_started?
      not last_event_started?
    end

end


