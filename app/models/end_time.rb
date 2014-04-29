class EndTime
  def self.for(end_time)
    if end_time.empty?
      StartTime.for(end_time) + 30.minutes
    else 
      end_time
    end
  end
end
