class Event < ActiveRecord::Base
  include IceCube
  validates :name, :from_date, :to_date, :time_zone, :repeats, presence: true
  validates :from_time,:to_time, presence: true, :if => :not_all_day?

  #validates :repeats_every_n_weeks, :presence => true, :if => lambda { |e| e.repeats == "weekly" }
  validate :must_have_at_least_one_repeats_weekly_each_days_of_the_week, :if => lambda { |e| e.repeats == "weekly" }
  validate :from_must_come_before_to

  RepeatsOptions = [ 'never','weekly' ]
  RepeatEndsOptions = ['never','on']
  RepeatMonthlyOptions = ['each','on']
  DaysOfTheWeek = %w[monday tuesday wednesday thursday friday saturday sunday]
  Ordinals = [1,2,3,4,-1]
  HumanOrdinals = ['first','second','third','fourth','last']


  def not_all_day?
    if is_all_day
      return false
    else
      return true
    end
  end

  def repeats_weekly_each_days_of_the_week=(repeats_weekly_each_days_of_the_week)
    self.repeats_weekly_each_days_of_the_week_mask = (repeats_weekly_each_days_of_the_week & DaysOfTheWeek).map { |r| 2**DaysOfTheWeek.index(r) }.inject(0, :+)
  end
  def repeats_weekly_each_days_of_the_week
    DaysOfTheWeek.reject do |r|
      ((repeats_weekly_each_days_of_the_week_mask || 0) & 2**DaysOfTheWeek.index(r)).zero?
    end
  end

  def repeats_monthly_each_days_of_the_month=(repeats_monthly_each_days_of_the_month)
    repeats_monthly_each_days_of_the_month.map!{|d| d.to_i} # They come in as strings, but our array is full of integers
    self.repeats_monthly_each_days_of_the_month_mask = (repeats_monthly_each_days_of_the_month & DaysOfTheMonth).map { |r| 2**DaysOfTheMonth.index(r) }.inject(0, :+)
  end
  def repeats_monthly_each_days_of_the_month
    DaysOfTheMonth.reject do |r|
      ((repeats_monthly_each_days_of_the_month_mask || 0) & 2**DaysOfTheMonth.index(r)).zero?
    end
  end

  def repeats_monthly_on_ordinals=(repeats_monthly_on_ordinals)
    repeats_monthly_on_ordinals.map!{|o| o.to_i} # They come in as strings, but our array is full of integers
    self.repeats_monthly_on_ordinals_mask = (repeats_monthly_on_ordinals & Ordinals).map { |r| 2**Ordinals.index(r) }.inject(0, :+)
  end
  def repeats_monthly_on_ordinals
    Ordinals.reject do |r|
      ((repeats_monthly_on_ordinals_mask || 0) & 2**Ordinals.index(r)).zero?
    end
  end

  def repeats_monthly_on_days_of_the_week=(repeats_monthly_on_days_of_the_week)
    self.repeats_monthly_on_days_of_the_week_mask = (repeats_monthly_on_days_of_the_week & DaysOfTheWeek).map { |r| 2**DaysOfTheWeek.index(r) }.inject(0, :+)
  end
  def repeats_monthly_on_days_of_the_week
    DaysOfTheWeek.reject do |r|
      ((repeats_monthly_on_days_of_the_week_mask || 0) & 2**DaysOfTheWeek.index(r)).zero?
    end
  end

  def repeats_yearly_each_months_of_the_year=(repeats_yearly_each_months_of_the_year)
    self.repeats_yearly_each_months_of_the_year_mask = (repeats_yearly_each_months_of_the_year & MonthsOfTheYear).map { |r| 2**MonthsOfTheYear.index(r) }.inject(0, :+)
  end
  def repeats_yearly_each_months_of_the_year
    MonthsOfTheYear.reject do |r|
      ((repeats_yearly_each_months_of_the_year_mask || 0) & 2**MonthsOfTheYear.index(r)).zero?
    end
  end

  def repeats_yearly_on_ordinals=(repeats_yearly_on_ordinals)
    repeats_yearly_on_ordinals.map!{|o| o.to_i} # They come in as strings, but our array is full of integers
    self.repeats_yearly_on_ordinals_mask = (repeats_yearly_on_ordinals & Ordinals).map { |r| 2**Ordinals.index(r) }.inject(0, :+)
  end
  def repeats_yearly_on_ordinals
    Ordinals.reject do |r|
      ((repeats_yearly_on_ordinals_mask || 0) & 2**Ordinals.index(r)).zero?
    end
  end

  def repeats_yearly_on_days_of_the_week=(repeats_yearly_on_days_of_the_week)
    self.repeats_yearly_on_days_of_the_week_mask = (repeats_yearly_on_days_of_the_week & DaysOfTheWeek).map { |r| 2**DaysOfTheWeek.index(r) }.inject(0, :+)
  end
  def repeats_yearly_on_days_of_the_week
    DaysOfTheWeek.reject do |r|
      ((repeats_yearly_on_days_of_the_week_mask || 0) & 2**DaysOfTheWeek.index(r)).zero?
    end
  end

  def from
    if is_all_day
      ActiveSupport::TimeZone[time_zone].parse(from_date.to_datetime.strftime('%Y-%m-%d')).beginning_of_day
    else
      ActiveSupport::TimeZone[time_zone].parse(from_date.to_datetime.strftime('%Y-%m-%d')).beginning_of_day + from_time.seconds_since_midnight
    end
  end

  def to
    if is_all_day
      ActiveSupport::TimeZone[time_zone].parse(to_date.to_datetime.strftime('%Y-%m-%d')).end_of_day
    else
      ActiveSupport::TimeZone[time_zone].parse(to_date.to_datetime.strftime('%Y-%m-%d')).beginning_of_day + to_time.seconds_since_midnight
    end
  end

  def duration
    d = to - from - 1
  end

  def schedule(starts_at = nil, ends_at = nil)
    starts_at ||= from
    ends_at ||= to
    if duration > 0
      s = IceCube::Schedule.new(starts_at, :ends_time => ends_at, :duration => duration)
    else
      s = IceCube::Schedule.new(starts_at, :ends_time => ends_at)
    end
    case repeats
      when 'never'
        s.add_recurrence_time(starts_at)
      when 'weekly'
        days = repeats_weekly_each_days_of_the_week.map {|d| d.to_sym }
        s.add_recurrence_rule IceCube::Rule.weekly(repeats_every_n_weeks).day(*days)
    end
    return s
  end


  private
  def must_have_at_least_one_repeats_weekly_each_days_of_the_week
    if repeats_weekly_each_days_of_the_week.empty?
      errors.add(:base, "You must have at least one repeats weekly each days of the week")
    end
  end

  def must_have_at_least_one_repeats_monthly_each_days_of_the_month
    if repeats_monthly_each_days_of_the_month.empty?
      errors.add(:base, "You must have at least one repeats monthly each days of the month")
    end
  end

  def must_have_at_least_one_repeats_monthly_on_ordinals
    if repeats_monthly_on_ordinals.empty?
      errors.add(:base, "You must have at least one repeats monthly on ordinals")
    end
  end

  def must_have_at_least_one_repeats_monthly_on_days_of_the_week
    if repeats_monthly_on_days_of_the_week.empty?
      errors.add(:base, "You must have at least one repeats monthly on days of the week")
    end
  end

  def must_have_at_least_one_repeats_yearly_each_months_of_the_year
    if repeats_yearly_each_months_of_the_year.empty?
      errors.add(:base, "You must have at least one repeats yearly each months of the year")
    end
  end

  def must_have_at_least_one_repeats_yearly_on_ordinals
    if repeats_yearly_on_ordinals.empty?
      errors.add(:base, "You must have at least one repeats yearly on ordinals")
    end
  end

  def must_have_at_least_one_repeats_yearly_on_days_of_the_week
    if repeats_yearly_on_days_of_the_week.empty?
      errors.add(:base, "You must have at least one repeats yearly on days of the week")
    end
  end

  def from_must_come_before_to
    if from > to
      errors.add(:to_date, "must come after the from date")
    end
  end


end