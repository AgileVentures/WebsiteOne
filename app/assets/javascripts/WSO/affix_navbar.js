//= require ./wso

WSO.define('AffixedNavbar', function() {
  var isAffixed, affixedNav, header, main, footer, thresholdTop,
      isListening = false;

  function onScroll() {
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

  function init() {
    affixedNav = $('#nav');
    header = $('#main_header');
    main = $('#main');
    thresholdTop = header.height();
    footer = $('#footer');
    isAffixed = affixedNav.hasClass('affix');

    if (!isListening) {
      $(window).scroll(onScroll);
      $(window).scroll();
      isListening = true;
    }
  }

  return {
    init: init,
    onScroll: onScroll
  }
});