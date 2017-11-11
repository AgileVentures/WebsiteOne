json.array! @subscriptions do |subscription|
  json.email subscription.user.email
  #date_format = subscription.all_day_event? ? '%Y-%m-%d' : '%Y-%m-%dT%H:%M:%S'
  #json.id subscription.id
  #json.title subscription.title
  #json.start subscription.start_date.strftime(date_format)
  #json.end subscription.end_date.strftime(date_format)
end
