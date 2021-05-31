# frozen_string_literal: true

json.array! @events do |event|
  # date_format = event.all_day_event? ? '%Y-%m-%d' : '%Y-%m-%dT%H:%M:%S'
  date_format = '%Y-%m-%dT%H:%M:%S'
  json.title event[:event].name
  json.start event[:time].strftime(date_format)
  end_time = event[:time] + event[:event].duration * 60
  json.end end_time.strftime(date_format)
  json.description event[:event].description
end
