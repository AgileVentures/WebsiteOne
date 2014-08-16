class StartTime 
  def self.for(start_time) 
    if start_time.blank?
      30.minutes.ago
    else 
      start_time
    end
  end
end
