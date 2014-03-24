module VisitorsHelper
  def display_countdown(days_left, hours_left, minutes_left)
    #@days_left   @hours_left   @minutes_left
    if days_left == 0
      "#{hours_left} hours #{minutes_left} minutes"
    else
      "#{days_left} days #{hours_left} hours #{minutes_left} minutes"
    end
  end
end
