import "./jq"
import "./jquery-ui"
import * as WebsiteOne from './websiteone';
import "./bootstrap";
import "./bootstrap-tags";
import "moment";
import "moment-timezone";
import "fullcalendar";
import "@nathanvda/cocoon";
import "trix";
import './global-modules/*.js';
import './documents';
import './projects';
import './events';
import './users';
import LocalTime from "local-time";
import './controllers/*.js';

LocalTime.start()

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
