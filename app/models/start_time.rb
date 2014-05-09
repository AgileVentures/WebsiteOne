class StartTime 
  def self.for(start_time) 
    if start_time.blank?
      Time.now
    else 
      start_time
    end
  end
end
