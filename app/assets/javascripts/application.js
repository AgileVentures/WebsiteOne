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
//= require jquery_ujs
//= require turbolinks
//= require jquery.turbolinks
//= require bootstrap
//= require nprogressbar
//= require bootstrap-datepicker
//= require bootstrap-timepicker
//= require typeahead
//= require bootstrap-tokenfield.min
//= require bootstrap-tags
//= require bootstrap/modal

// Bryan: removed require_tree . because mercury causes problems if loaded on every page

$(function() {
  $.fn.BryanHATESTHIS = function () {
    // Bryan: run these functions only in the home page
    if (window.location.pathname === '/') {
      var TxtRotate = function(el, toRotate, period) {
        this.toRotate = toRotate;
        this.el = el;
        this.loopNum = 0;
        this.period = parseInt(period, 10) || 2000;
        this.txt = '';
        this.tick();
        this.isDeleting = false;
      };

      TxtRotate.prototype.tick = function() {
        var i = this.loopNum % this.toRotate.length;
        var fullTxt = this.toRotate[i];

        if (this.isDeleting) {
          this.txt = fullTxt.substring(0, this.txt.length - 1);
        } else {
          this.txt = fullTxt.substring(0, this.txt.length + 1);
        }

        this.el.innerHTML = '<span class="wrap">'+this.txt+'</span>';

        var that = this;
        var delta = 300 - Math.random() * 100;

        if (this.isDeleting) { delta /= 2; }

        if (!this.isDeleting && this.txt === fullTxt) {
          delta = this.period;
          this.isDeleting = true;
        } else if (this.isDeleting && this.txt === '') {
          this.isDeleting = false;
          this.loopNum++;
          delta = 500;
        }

        setTimeout(function() {
          that.tick();
        }, delta);
      };

      var elements = document.getElementsByClassName('txt-rotate');
      for (var i=0; i<elements.length; i++) {
        var toRotate = elements[i].getAttribute('data-rotate');
        var period = elements[i].getAttribute('data-period');
        if (toRotate) {
          new TxtRotate(elements[i], JSON.parse(toRotate), period);
        }
      }
      // INJECT CSS
      var css = document.createElement("style");
      css.type = "text/css";
      css.innerHTML = ".txt-rotate > .wrap";
      document.body.appendChild(css);
    }

    var flash = $('#flash-container');
    if (flash.length > 0) {
      window.setTimeout(function() {
        flash.fadeTo(500, 0).slideUp(500, function(){
          $(this).remove();
        });
      }, 5000);
    }

    /**
     * Carousel collapse button, switches icons when the collapse/button icon is clicked and triggers sidebar
     * checking event. It listens to click events with CSS class 'collapse-button'
     *
     * To change the icons, alter collapsedClass and expandedClass to append the appropriate CSS classes
     */

    var collapsedClass = 'fa-caret-down',
        expandedClass = 'fa-caret-right';
    // a hack to follow collapse animation, ideally should find the right animation callbacks
    $('.collapse-button').on('click', function() {
      // TODO Bryan: This does not work properly if the user clicks too fast
      var child = $(this).find('>:first-child');
      if (child.hasClass(collapsedClass)) {
        child.removeClass(collapsedClass);
        child.addClass(expandedClass);
      } else if (child.hasClass(expandedClass)) {
        child.removeClass(expandedClass);
        child.addClass(collapsedClass);
      }
    });

    var affixedNav = $('#nav'),
        header = $('#main_header'),
        main = $('#main'),
    // manually selected properties which will affect affix threshold height, if layout changes,
    // readjust as necessary
        thresholdTop = header.height(),
        footer = $('#footer'),
        isAffixed = affixedNav.hasClass('affix');

    // Bryan: catch scroll events
    $(window).scroll(function() {

      var scrollTop = $(this).scrollTop();
      if (scrollTop > thresholdTop && !isAffixed) {
        affixedNav.addClass('affix');
        header.css({ 'margin-bottom': affixedNav.height() + parseInt(affixedNav.css('margin-bottom'))});
        isAffixed = true;
      } else if (scrollTop < thresholdTop && isAffixed) {
        // remove affix if the scroll is below threshold
        affixedNav.removeClass('affix');
        header.css({ 'margin-bottom': 0 });
        isAffixed = false;
      }
    });

    $(window).scroll();

    // Event Timer

    var eventCountdown = $('#next-event');
    if (eventCountdown.length > 0) {
      var eventTime = Date.parse(eventCountdown.data('event-time')),
          eventUrl = eventCountdown.data('event-url'),
          eventName = eventCountdown.data('event-name'),
          textToAppend = ' to <a href="' + eventUrl + '">' + eventName + '</a></p>';

      function toFormattedString(num) {
        return (num < 10) ? '0' + num : num.toString();
      }

      if (window.wsoUpdateCountdown) {
        clearTimeout(window.wsoUpdateCountdown);
      }

      window.wsoUpdateCountdown = function() {
        var timeToEvent = eventTime - new Date(),
            timeInSeconds = Math.floor(timeToEvent/1000),
            timeInMins = Math.floor(timeInSeconds/60),
            timeInHours = Math.floor(timeInMins/60);

        if (timeInSeconds <= 0) {
          eventCountdown.html('<a href="' + eventUrl + '">' + eventName + '</a> has started');
        } else {
          var tmp = '<p>';
          if (timeInHours > 0) {
            tmp += toFormattedString(timeInHours) + ':';
          }

          eventCountdown.html(tmp + toFormattedString(timeInMins % 60) +
                              ':' + toFormattedString(timeInSeconds % 60) +
                              textToAppend);
          setTimeout(window.wsoUpdateCountdown, 1000);
        }
      };

      window.wsoUpdateCountdown();
    }
  };


  $(document).on('page:fetch',   function() { NProgress.start(); });
  $(document).on('page:change',  function() { NProgress.done(); });
  $(document).on('page:restore', function() { NProgress.remove(); });

  $(document).ready($.fn.BryanHATESTHIS);
  $(document).on('page:load', $.fn.BryanHATESTHIS);
});


