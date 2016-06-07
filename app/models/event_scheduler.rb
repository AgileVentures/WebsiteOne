class EventScheduler < IceCube::Schedule
  include IceCube
  extend Forwardable

  COLLECTION_TIME_PAST      = 15.minutes
  COLLECTION_TIME_FUTURE    = 10.days

  delegate [:start_datetime, 
            :repeat_ends?,
            :repeats_weekly_each_days_of_the_week,
            :repeat_ends_on,
            :repeats_every_n_weeks, 
            :repeats,
            :next_event_occurrence_with_time_inner
            ] => :@event

  attr_reader :event

  def initialize(event)
    @event = event
    super(start_datetime)                                 unless repeat_ends?
    super(start_datetime, :end_time => series_end_time)   if repeat_ends?
    
    set_scheduler_type
    add_exception_periods
  end

  def self.next_occurrence(event_type, begin_time=COLLECTION_TIME_PAST.ago)
    events_with_times = select_events_with_time(event_type: event_type, begin_time: begin_time)

    if events_with_times.empty?
      return nil 
    else
      events_with_times = events_with_times.sort_by { |e| e[:time] }
      events_with_times[0][:event].next_occurrence_time_attr = events_with_times[0][:time]
      return events_with_times[0][:event]
    end
  end

  def next_event_occurrence_with_time_inner(start_time, end_time)
    occurrences = occurrences_between(start_time, end_time)
    # possible bug 'self', reference to wrong object
    { event: event, time: occurrences.first.start_time } if occurrences.present?
  end

  def remove_from_schedule(timedate)
    # best if schedule is serialized into the events record...  and an attribute.
    if timedate >= Time.now && timedate == next_occurrence_time_method
      _next_occurrences = next_occurrences(limit: 2)
      event.start_datetime = (_next_occurrences.size > 1) ? _next_occurrences[1][:time] : timedate + 1.day
    elsif timedate >= Time.now
      event.exclusions ||= []
      event.exclusions << timedate
    end
    event.save!
  end

  def start_datetime_for_collection(options = {})
    first_datetime = options.fetch(:start_time, COLLECTION_TIME_PAST.ago)
    first_datetime = [start_datetime, first_datetime.to_datetime].max
    first_datetime.to_datetime.utc
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
    begin_datetime = start_datetime_for_collection(options)
    final_datetime = final_datetime_for_collection(options)
    limit = options.fetch(:limit, 100)
    [].tap do |occurences|
      occurrences_between(begin_datetime, final_datetime).each do |time|
        # there should be some check !!??
        # occurences << { event: event, time: time } 
        occurences << time.to_datetime.utc
        return occurences if occurences.count >= limit
      end
    end
  end

  def next_occurrence_time_method(start = Time.now)
    next_occurrence = next_event_occurrence_with_time(start)
    next_occurrence.present? ? next_occurrence[:time] : nil
  end

  # The IceCube Schedule's occurrences_between method requires a time range as input to find the next time
  # Most of the time, the next instance will be within the next weeek. 
  # 
  # But some event instances may have been excluded, so there's not guarantee that the next time for an event
  # will be within the next week, or even the next month.
  #
  # To cover these cases, the while loop looks farther and farther into the future 
  # for the next event occurrence, just in case there are many exclusions.
  def next_event_occurrence_with_time(start = Time.now, final= 2.months.from_now)
    begin_datetime = start_datetime_for_collection(start_time: start)
    final_datetime = repeating_and_ends? ? repeat_ends_on : final
    n_days = 8
    end_datetime = n_days.days.from_now
    event = nil

    if repeats == 'never'
      return next_event_occurrence_with_time_inner(start, final_datetime)
    else 
      while event.nil? && end_datetime < final_datetime
        event = next_event_occurrence_with_time_inner(start, final_datetime)
        n_days *= 2
        end_datetime = n_days.days.from_now
      end  
    end
    
    event
  end

  def series_end_time
    repeat_ends_on.to_time    if repeat_ends? && repeat_ends_on.present? 
  end

  private 
    def self.select_events_with_time(args)
      event_type  = args.fetch(:event_type)
      begin_time  = args.fetch(:begin_time)

      Event.where(category: event_type).map do |event|
        event.next_event_occurrence_with_time(begin_time)
      end.compact
    end

    def set_scheduler_type
      days            = repeats_weekly_each_days_of_the_week.map { |d| d.to_sym }
      schedule_rule   = IceCube::Rule.weekly(repeats_every_n_weeks).day(*days)

      self.add_recurrence_time(start_datetime)    if repeats == 'never'
      self.add_recurrence_rule(schedule_rule)     if repeats == 'weekly'
    end

    def add_exception_periods
      event.exclusions ||= []
      event.exclusions.each {|ex| self.add_exception_time(ex) }
    end

    def repeating_and_ends?
      repeats != 'never' && repeat_ends? && !repeat_ends_on.blank?
    end
end