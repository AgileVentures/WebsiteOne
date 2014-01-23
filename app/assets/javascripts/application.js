// This is a manifest file that'll be compiled into application.js, which will include all the files
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

// Bryan: removed require_tree . because mercury causes problems if loaded on every page


$(function() {
  function ready() {
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

    /*
      AFFIX BEHAVIOUR RELATED CODE
     */

    var affixedNav = $('#nav'),
        header = $('#main_header'),
        wrapper = $('#wrap'),
        sidebar = $('#sidebar'),
        notSidebar = $('#not-sidebar'),
        headerHeight = header.height();

    // only worry about the complex sidebar behaviour if the sidebar is shorter than the actual document
    var worryAboutSidebar = (sidebar != null) && (sidebar.height() < notSidebar.height());

    if (sidebar != null) {
      sidebar.css({ 'max-height': 500 });
    }

    function adjustSidebarPosition() {
      // TODO Bryan: avoid hardcoded values if possible
      var diff = $(window).scrollTop() + sidebar.height() + 700 - $(document).height();
      if (diff > 0) {
        sidebar.css({ 'top': affixedNav.height() + 125 - diff });
      }
    }

    // TODO Bryan: this works but gives jittery animation
    var h1 = 0,
        h2 = 0,
        checkDelay = 30; // can't seem to go too low
    function checkSidebarHeight() {
      h2 = sidebar.height();
      worryAboutSidebar = (h2 < notSidebar.height());
      if (h1 != h2) {
        adjustSidebarPosition();
        h1 = h2;
        setTimeout(checkSidebarHeight, checkDelay);
      }

      if (!worryAboutSidebar) {
        sidebar.removeClass('affix');
        sidebar.css({ 'top': 0 });
      }
    }

    // a hack to follow collapse animation, ideally should find the right animation callbacks
    $('.project-collapse').on('click', function() {
      h1 = h2 = sidebar.height();
      if ($(window).scrollTop() > headerHeight) {
        setTimeout(checkSidebarHeight, checkDelay);
      }
    });

    $(window).scroll(function() {
      if ($(this).scrollTop() > headerHeight) {
        if (!affixedNav.hasClass('affix')) {
          affixedNav.addClass('affix');
          wrapper.css({ 'padding-top': affixedNav.height() + parseInt(affixedNav.css('margin-bottom')) });
          if (worryAboutSidebar) {
            sidebar.addClass('affix');
            // TODO Bryan: avoid hardcoded values if possible
            sidebar.css({ 'top': affixedNav.height() + 125 });
          }
        }
        if (worryAboutSidebar) {
          adjustSidebarPosition();
        }
      } else if (affixedNav.hasClass('affix')) {
        affixedNav.removeClass('affix');
        wrapper.css({ 'padding-top': 0 });
        if (worryAboutSidebar) {
          sidebar.removeClass('affix');
          sidebar.css({ 'top': 0 });
        }
      }
    });
  }

  $(document).ready(ready);
  $(document).on('page:load', ready);
});
