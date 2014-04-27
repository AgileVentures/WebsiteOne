class EventDate 
  def self.for(event_date) 
    if event_date.empty?
      Date.today
    else 
      event_date
    end
  end
end
