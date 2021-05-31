# frozen_string_literal: true

class DateTime
  def distance_to(end_date)
    s = end_date.to_i - to_i
    # s = end_date.to_i - Time.now.to_datetime.to_i
    minutes, seconds = s.divmod(60)
    hours, minutes = minutes.divmod(60)
    days, hours = hours.divmod(24)
    { seconds: seconds, minutes: minutes, hours: hours, days: days }
  end
end
