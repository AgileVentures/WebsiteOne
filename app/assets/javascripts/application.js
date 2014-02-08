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

// Bryan: removed require_tree . because mercury causes problems if loaded on every page

$(function() {
  function ready() {
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
     * SIDEBAR AFFIX BEHAVIOUR RELATED CODE
     *
     * Why not use Bootstrap affix?
     * 1. Well first off, the header margins needs to be adjusted to compensate for affixing
     *    the navbar, which bootstrap appears to not have any callbacks for.
     * 2. Second, the current available implementation of bootstrap is buggy for affix-bottom,
     *    it is a little extra work to have it working
     *    related bug: https://github.com/twbs/bootstrap/issues/4647
     * 3. There is no guarantee that embedded collapsible items will work well with Bootstrap's affix
     *
     * HOW IT WORKS
     *
     * A custom object is attached to the sidebar, which acts as a state machine, monitoring its own state
     * and providing helper functions to set the state. There are three possible states:
     *
     * AFFIX_TOP  - The sidebar is docked to the top of the page. In this state, it occupies space
     * AFFIX      - The sidebar is now floating. In this state, it does not occupy space
     * AFFIX_BTM  - The sidebar is docked to the bottom of the page. In this state, it occupies space
     *
     * To achieve this affect, the sidebar parent is given a relative position attribute. The sidebar top and
     * bottom properties are adjusted accordingly. In the AFFIX state, the sidebar position is set to fixed.
     *
     * NOTE: The threshold for changing states are calculated based on the layout at the time of writing,
     *       any changes could affect the alignment of the sidebar docking positions
     *
     * @author Bryan Yap
     */

    var affixedNav = $('#nav'),
        header = $('#main_header'),
        sidebar = $('#sidebarnav'),
        notSidebar = $('#not-sidebar'),
        sidebarContainer = $('#sidebar-container'),
        wrapper = $('#wrap'),
        main = $('#main'),
        // manually selected properties which will affect affix threshold height, if layout changes,
        // readjust as necessary
        thresholdTop = header.height() + affixedNav.height(),
        footer = $('#footer'),
        // manually selected properties which will affect affix threshold height, if layout changes,
        // readjust as necessary
        bottomThreshold = parseInt(footer.css('margin-top')) + footer.height() +
            parseInt(footer.css('padding-top')) + parseInt(footer.css('padding-bottom')),
        affixOffsetHeight = parseInt(affixedNav.css('margin-bottom')) + parseInt(main.css('padding-top')),
        mainTopPadding = parseInt(main.css('padding-top')),
        mobileWidth = 768; // Bryan: Based on Bootstrap's 3 docs

    // only worry about the complex sidebar behaviour if the sidebar is shorter than the actual document
    var worryAboutSidebar = (sidebar != null) && (sidebar.height() < notSidebar.height()) && ($(window).width() > mobileWidth);

    if (sidebar != null) {
      // attach a custom object
      sidebar.custom = {
        AFFIX_TOP:  0,
        AFFIX:      1,
        AFFIX_BTM:  2,
        state:      0,  // Bryan: AFFIX_TOP is not guaranteed to be defined at initialization
        affixTop: function() {
          if (this.state === this.AFFIX_TOP) return;
          // Bryan: turns off any per element styling
          sidebar.css({
            'position': '',
            'top': '',
            'left': '',
            'bottom': '',
            'width': ''
          });
          this.state = this.AFFIX_TOP;
        },
        affix: function() {
          if (this.state === this.AFFIX) return;
          // Bryan: affixOffsetHeight must be tuned to work correctly
          sidebar.css({
            'position': 'fixed',
            'top': affixOffsetHeight,
            'left': 'auto',
            'bottom': '',
            'width': sidebarContainer.width() * 0.25 // assuming col-3 is being used
          });
          this.state = this.AFFIX;
        },
        affixBottom: function() {
          if (this.state === this.AFFIX_BTM) return;
          // Bryan: The left property must be tuned to work properly, in this case, it is just the left padding
          sidebar.css({
            'position': 'absolute',
            'top': 'auto',
            'left': $('#sidebar-container').css('padding-left'),
            'bottom': main.height() + mainTopPadding - wrapper.height(),
            'width': sidebarContainer.width() * 0.25
          });
          this.state = this.AFFIX_BTM;
        },
        onResize: function() {
          worryAboutSidebar = (sidebar.height() < notSidebar.height()) && ($(window).width() > mobileWidth);
          sidebar.css({ 'max-height': $(window).height() - thresholdTop - 40 }); // Bryan: 40px bottom padding
          if (worryAboutSidebar && ($(window).scrollTop() > thresholdTop)) {
            this.affix();
            this.checkBottom();
            if (this.state !== this.AFFIX_TOP) {
              sidebar.css({ 'width': sidebarContainer.width() * 0.25 });
            }
          } else {
            this.affixTop();
          }
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

      $(window).resize(function() {
        sidebar.custom.onResize();
      });

      sidebar.custom.onResize();
    }

    // TODO Bryan: a similar function for watching main content height, IF collapsible content exists
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
      // TODO Bryan: This does not work properly if the user clicks too fast
      var child = $(this).find('>:first-child');
      if (child.hasClass('fa-caret-down')) {
        child.removeClass('fa-caret-down');
        child.addClass('fa-caret-up');
      } else if (child.hasClass('fa-caret-up')) {
        child.removeClass('fa-caret-up');
        child.addClass('fa-caret-down');
      }
      // catch any collapsing element
      h1 = h2 = sidebar.height();
      if (sidebar.custom.state != sidebar.custom.AFFIX_TOP && $(window).width() > mobileWidth) {
        oldState = sidebar.custom.state;
        setTimeout(checkSidebarHeight, checkDelay);
      }
    });

    // Bryan: catch scroll events
    $(window).scroll(function() {
      if ($(this).scrollTop() > thresholdTop) {
        // add affix behaviour if scroll is above threshold
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
        // remove affix if the scroll is below threshold
        affixedNav.removeClass('affix');
        header.css({ 'margin-bottom': 0 });
        if (worryAboutSidebar) {
          sidebar.custom.affixTop();
        }
      }
    });
  }



  $(document).on('page:fetch',   function() { NProgress.start(); });
  $(document).on('page:change',  function() { NProgress.done(); });
  $(document).on('page:restore', function() { NProgress.remove(); });

  $(document).ready(ready);
  $(document).on('page:load', ready);
});
