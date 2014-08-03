class EndTime
  def self.for(end_time, time_in_future = 30.minutes)
    if end_time.blank?
      StartTime.for(end_time) + time_in_future
    else 
      end_time
    end
  end
end
