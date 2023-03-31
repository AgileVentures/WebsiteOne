// To deal with the headache of initializing JavaScripts with TurboLinks, I
// wrote this custom module definer to handle initialization code
//
// modules can be defined using the following snippet:
//
// window.WebsiteOne.define('<Module Name>', function() {
//     return <Module Object>;
// });
//
// The module's init method will automatically be called on TurboLink's
// page:load or document ready event
import "./jq"
import "./jquery-ui"
import * as WebsiteOne from './websiteone';
import "./bootstrap";
import "./bootstrap-datepicker";
import "./bootstrap-timepicker.min";
// import "typeahead.jquery";
// import "./bootstrap-tokenfield.min";
import "./bootstrap-tags";
import "lolex";
import "fullcalendar";
import "trix";
import './global-modules/*.js';
import './event_datepicker';
import './event_instances';

$(function() {
  if (!window.WebsiteOne._registered) {
    $(document).ready(window.WebsiteOne._init);
    $(document).on('page:load', window.WebsiteOne._init);

    window.WebsiteOne._registered = true;
  }
});

$(function() {
  $('#calendar').fullCalendar({
    header: {
      right: 'prev, next, today, month, agendaWeek, agendaDay'
    },
    events: function(start, end, timezone, callback) {
      var timezoneoffset = new Date().getTimezoneOffset();
      var events = [];
      $.ajax({
        url: '/events.json',
        success: function(doc) {
          $.map(doc, function(event) {
            event.start = moment.utc(event.start).local();
            event.end = moment.utc(event.end).local();
            events.push(event);
          });
          callback(events);
        }
      });
    }
  });
});

function infiniteScroll(params) {
  $(window).scroll(function() {
    var url = $('.pagination a[rel="next"]').attr('href');
    if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 450) {
      $('.pagination').text("Please Wait...");
      return $.getScript(url + params);
    }
  });
}
