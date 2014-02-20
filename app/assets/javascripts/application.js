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
//= require bootstrap
//= require nprogressbar
//= require 404

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

    window.setTimeout(function() {
      $(".flash-div").fadeTo(500, 0).slideUp(500, function(){
        $(this).remove();
      });
    }, 5000);

    /**
     * Carousel collapse button, switches icons when the collapse/button icon is clicked and triggers sidebar
     * checking event. It listens to click events with CSS class 'collapse-button'
     *
     * To change the icons, alter collapsedClass and expandedClass to append the appropriate CSS classes
     */

//    var collapsedClass = 'fa-caret-down',
//        expandedClass = 'fa-caret-right';
//    // a hack to follow collapse animation, ideally should find the right animation callbacks
//    $('.collapse-button').on('click', function() {
//      // TODO Bryan: This does not work properly if the user clicks too fast
//      var child = $(this).find('>:first-child');
//      if (child.hasClass(collapsedClass)) {
//        child.removeClass(collapsedClass);
//        child.addClass(expandedClass);
//      } else if (child.hasClass(expandedClass)) {
//        child.removeClass(expandedClass);
//        child.addClass(collapsedClass);
//      }
//    });

      var affixedNav = $('#nav'),
          header = $('#main_header'),
          main = $('#main'),
      // manually selected properties which will affect affix threshold height, if layout changes,
      // readjust as necessary
          thresholdTop = header.height() + affixedNav.height(),
          footer = $('#footer');

    // Bryan: catch scroll events
    $(window).scroll(function() {

        if ($(this).scrollTop() > thresholdTop) {
        // add affix behaviour if scroll is above threshold
        if (!affixedNav.hasClass('affix')) {
          affixedNav.addClass('affix');
          header.css({ 'margin-bottom': affixedNav.height() + parseInt(affixedNav.css('margin-bottom'))});
        }
      } else if (affixedNav.hasClass('affix')) {
        // remove affix if the scroll is below threshold
        affixedNav.removeClass('affix');
        header.css({ 'margin-bottom': 0 });
      }
    });
  }



  $(document).on('page:fetch',   function() { NProgress.start(); });
  $(document).on('page:change',  function() { NProgress.done(); });
  $(document).on('page:restore', function() { NProgress.remove(); });

  $(document).ready($.fn.BryanHATESTHIS);
  $(document).on('page:load', $.fn.BryanHATESTHIS);
});
