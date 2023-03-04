# frozen_string_literal: true

class CalendarController < ApplicationController
  def index
    cal = Icalendar::Calendar.new
    filename = 'AgileVentures_events'

    if params[:format] == 'vcs'
      cal.prodid = '-//Microsoft Corporation//Outlook MIMEDIR//EN'
      cal.version = '1.0'
      filename += '.vcs'
    else # ical
      cal.prodid = '-//Acme Widgets, Inc.//NONSGML ExportToCalendar//EN'
      cal.version = '2.0'
      filename += '.ics'
    end
    add_events cal
    send_data cal.to_ical, type: 'text/calendar', disposition: 'attachment', filename: filename
  end

  private

  def add_events(cal)
    events_all = Event.upcoming_events
    events_all.each do |event_instance|
      event             = Icalendar::Event.new
      event.dtstart     = Icalendar::Values::DateTime.new(event_instance[:time],
                                                          tzid: event_instance[:event].time_zone)
      event.dtend       = Icalendar::Values::DateTime.new(
        event_instance[:time] + (60 * event_instance[:event].duration), tzid: event_instance[:event].time_zone
      )
      event.summary     = event_instance[:event].name
      event.description = event_instance[:event].description

      cal.add_event(event)
    end
  end
end
