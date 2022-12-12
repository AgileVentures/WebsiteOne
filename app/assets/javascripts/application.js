// This is a manifest file that will be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require bootstrap
//= require nprogress
//= require bootstrap-datepicker
//= require bootstrap-timepicker.min
//= require typeahead.jquery
//= require bootstrap-tokenfield.min
//= require bootstrap-tags
//= require_self
//= require_directory ./global-modules
//= require_tree .
//= stub mercury_init
//= stub google-analytics
//= stub disqus
//= require events
//= stub event_instances
//= stub hangout_play_on_hover
//= require local-time
//= require jvectormap
//= require jvectormap/maps/world_mill
//= require moment.min
//= require moment-timezone-with-data-2012-2022.js
//= require cocoon
//= require fullcalendar
//= require lolex
//= require spin
//= require jquery.spin

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

window.WebsiteOne =
  window.WebsiteOne ||
  (function() {
    var modules = [],
      newPageLoaded = false,
      runOnceCallbacks = {},
      restoreModules = {};

    //hook for spec helper to hook into to get the original factory
    //and restore it
    function restoreModule(name){
      define(name, moduleFactories[name]);
    }

    function define(name, factory) {
      window.WebsiteOne[name] =
        window.WebsiteOne[name] ||
        (function() {
          modules.push(name);
          var newModule = factory();
          //bit of a hack to support jasmine unit testing!
          moduleFactories[name] = factory;

          if (!window.WebsiteOne._newPageLoaded) {
            newModule.init();
          }

          return newModule;
        })();

      return window.WebsiteOne[name];
    }

    function runOnce(name, callback) {
      runOnceCallbacks[name] = runOnceCallbacks[name] || {
        callback: callback,
        executed: false
      };
    }

    function clear() {
      for (var i = 0; i < modules.length; i++) {
        console.log(modules[i]);
        delete window.WebsiteOne[modules[i]];
      }
      modules.length = 0;
    }

    function init() {
      for (var i = 0; i < modules.length; i++) {
        window.WebsiteOne[modules[i]].init();
      }

      for (var name in runOnceCallbacks) {
        if (!runOnceCallbacks[name].executed) {
          runOnceCallbacks[name].callback();
          runOnceCallbacks[name].executed = true;
        }
      }

      window.WebsiteOne._newPageLoaded = false;
    }

    return {
      _init: init,
      define: define,
      runOnce: runOnce,
      _modules: modules,
      _registered: false,
      _newPageLoaded: newPageLoaded,
      _clear: clear,
      _restoreModule: restoreModule
    };
  })();

window.WebsiteOne._newPageLoaded = true;

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
