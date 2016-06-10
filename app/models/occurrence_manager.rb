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

  COLLECTION_TIME_PAST    = 15.minutes
  COLLECTION_TIME_FUTURE  = 10.days

  attr_reader :event
  def initialize(event)
    @event = event
  end

  # CLASS METHODS BEGIN
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
  # CLASS METHODS END

  # NEXT OCCURRENCES RELATED BEGIN
  def next_occurrences(options = {})
    begin_datetime    = start_datetime_for_collection(options)
    final_datetime    = final_datetime_for_collection(options)
    limit             = options.fetch(:limit, 100)
    result            = []
    
    all_occurrences_for(begin_datetime, final_datetime, limit) {|evt| result << evt }
    result
  end

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

  def all_occurrences_for(start_time, end_time, limit, &block)
    occurrences_between(start_time, end_time).each_with_index do |time, index|
      block.call({ event: event, time: time })
      break if index + 1 >= limit
    end
  end
  # NEXT OCCURRENCES RELATED END

  # NEXT OCCURRENCE RELATED BEGIN
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
  # NEXT OCCURRENCE RELATED END

  private   
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

