//= require ./wso

WSO.define('AffixedNavbar', function() {

  function AffixedNavbar() {
    var isAffixed, affixedNav, header, main, footer, thresholdTop,
        isListening = false;

    this.onScroll = function() {
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
    }

    this.init = function() {
      affixedNav = $('#nav');
      header = $('#main_header');
      main = $('#main');
      thresholdTop = header.height();
      footer = $('#footer');
      isAffixed = affixedNav.hasClass('affix');

      if (!isListening) {
        $(window).scroll(this.onScroll);
        $(window).scroll();
        isListening = true;
      }
    }
  }

  return new AffixedNavbar();
});
