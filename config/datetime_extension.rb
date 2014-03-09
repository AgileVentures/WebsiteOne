class DateTime
  def distance_to(end_date)
    days = end_date.day - day
    hours = end_date.hour - hour
    minutes = end_date.minute - minute
    if hours < 0
      hours += 24
      days -= 1
    end
    if minutes < 0
      minutes += 60
      hours -= 1
    end
    {:minutes => minutes, :hours => hours, :days => days}
  end
end