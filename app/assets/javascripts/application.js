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

    $('.collapse-button').on('click', function() {
      child = $(this).find('>:first-child');
      if (child.hasClass('glyphicon-chevron-down')) {
        child.removeClass('glyphicon-chevron-down');
        child.addClass('glyphicon-chevron-up');
      } else {
        child.removeClass('glyphicon-chevron-up');
        child.addClass('glyphicon-chevron-down');
      }
    });

    /*
      AFFIX BEHAVIOUR RELATED CODE

      Why not use Bootstrap affix?
      1. Well first off, the header margins needs to be adjusted to compensate for affixing
         the navbar, which bootstrap appears to not have any callbacks for.
      2. Second, the current available implementation of bootstrap is buggy for affix-bottom,
         it is a little extra work to have it working
         related bug: https://github.com/twbs/bootstrap/issues/4647
      3. There is no guarantee that embedded collapsible items will work well with affix
     */

    var affixedNav = $('#nav'),
        header = $('#main_header'),
        sidebar = $('#sidebar'),
        notSidebar = $('#not-sidebar'),
        // manually selected properties which will affect affix threshold height, if layout changes,
        // readjust as necessary
        thresholdHeight = header.height() + affixedNav.height(),
        footer = $('#footer'),
        // manually selected properties which will affect affix threshold height, if layout changes,
        // readjust as necessary
        bottomThreshold = parseInt(footer.css('margin-top')) + footer.height() +
            parseInt(footer.css('padding-top')) + parseInt(footer.css('padding-bottom')),
        affixOffsetHeight = parseInt(affixedNav.css('margin-bottom')) + parseInt($('#main').css('padding-top'));

    if (sidebar != null) {
      sidebar.css({ 'max-height': 300 }); // TODO Bryan: hardcoded value...

      sidebar.custom = {
        AFFIX_TOP:  0,
        AFFIX:      1,
        AFFIX_BTM:  2,
        state: this.AFFIX_TOP,
        affixTop: function() {
          if (this.state == this.AFFIX_TOP) return;
          // Bryan: turns off any per element styling
          sidebar.css({ 'position': '', 'top': '', 'left': '', 'bottom': '' })
          this.state = this.AFFIX_TOP;
        },
        affix: function() {
          if (this.state == this.AFFIX) return;
          // Bryan: affixOffsetHeight must be tuned to work correctly
          sidebar.css({ 'position': 'fixed', 'top': affixOffsetHeight, 'left': 'auto', 'bottom': '' })
          this.state = this.AFFIX;
        },
        affixBottom: function() {
          if (this.state == this.AFFIX_BTM) return;
          // Bryan: The left property must be tuned to work properly, in this case, it is just the left padding
          sidebar.css({ 'position': 'absolute', 'top': 'auto', 'left': $('#sidebar-container').css('padding-left'), 'bottom': 0 })
          this.state = this.AFFIX_BTM;
        },
        checkBottom: function() {
          var diff = $(window).scrollTop() + affixOffsetHeight + sidebar.height() + bottomThreshold - $(document).height();
          if (diff > 0) {
            this.affixBottom();
          } else {
            this.affix();
          }
        }
      };
    }

    // only worry about the complex sidebar behaviour if the sidebar is shorter than the actual document
    var worryAboutSidebar = (sidebar != null) && (sidebar.height() < notSidebar.height());

    var h1 = 0,
        h2 = 0,
        oldState = 0,
        checkDelay = 30; // can't seem to go too low
    function checkSidebarHeight() {
      h2 = sidebar.height();
      worryAboutSidebar = (h2 < notSidebar.height());
      if (h1 != h2) {
        sidebar.custom.checkBottom();
        h1 = h2;
        if (oldState == sidebar.custom.state) {
          setTimeout(checkSidebarHeight, checkDelay);
        }

        if (!worryAboutSidebar) {
          sidebar.custom.affixTop();
        }
      }
    }

    // a hack to follow collapse animation, ideally should find the right animation callbacks
    $('.collapse-button').on('click', function() {
      h1 = h2 = sidebar.height();
      if (sidebar.custom.state != sidebar.custom.AFFIX_TOP) {
        oldState = sidebar.custom.state;
        setTimeout(checkSidebarHeight, checkDelay);
      }
    });

    $(window).scroll(function() {
      if ($(this).scrollTop() > thresholdHeight) {
        if (!affixedNav.hasClass('affix')) {
          affixedNav.addClass('affix');
          header.css({ 'margin-bottom': affixedNav.height() + parseInt(affixedNav.css('margin-bottom'))});
          if (worryAboutSidebar) {
            sidebar.custom.affix();
          }
        }
        if (worryAboutSidebar) {
          sidebar.custom.checkBottom();
        }
      } else if (affixedNav.hasClass('affix')) {
        affixedNav.removeClass('affix');
        header.css({ 'margin-bottom': 0 });
        if (worryAboutSidebar) {
          sidebar.custom.affixTop();
        }
      }
    });
  }

  $(document).ready(ready);
  $(document).on('page:load', ready);
});
