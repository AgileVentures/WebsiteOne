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

  def next_occurrence_time_method(start = Time.now)
    next_occurrence         = next_event_occurrence_with_time(start)
    next_occurrence.time    if next_occurrence.present?
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

