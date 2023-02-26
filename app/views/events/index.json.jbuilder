# frozen_string_literal: true

date_format = '%Y-%m-%dT%H:%M:%S'
json.array! @scrums do |scrum|
  json.title scrum.title
  json.start scrum.created_at.strftime(date_format)
  end_time = scrum.created_at + 1800
  json.end end_time.strftime(date_format)
end
json.array! @events do |event|
  json.title event[:event].name
  json.start event[:time].strftime(date_format)
  end_time = event[:time] + event[:event].duration * 60
  json.end end_time.strftime(date_format)
  json.description event[:event].description
end
