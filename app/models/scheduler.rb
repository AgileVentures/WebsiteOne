class Scheduler < IceCube::Schedule
  include IceCube
  extend Forwardable

  delegate [:start_datetime, 
            :repeat_ends?,
            :repeats_weekly_each_days_of_the_week,
            :repeat_ends_on,
            :repeats_every_n_weeks, 
            :repeats] => :@event

  attr_reader :event

  def initialize(event)
    @event = event
    super(start_datetime)                                 unless repeat_ends?
    super(start_datetime, :end_time => series_end_time)   if repeat_ends?
    
    set_scheduler_type
    add_exception_periods
  end

  def series_end_time
    repeat_ends_on.to_time    if repeat_ends? && repeat_ends_on.present? 
  end

  private 
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
end