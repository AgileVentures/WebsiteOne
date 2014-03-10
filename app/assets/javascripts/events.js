//
//(function ($, window, document, undefined) {
//
//  function ready() {
//    var gridContainer = $('#grid-container'),
//        filtersContainer = $('#filters-container');
//
//    // init cubeportfolio
//    gridContainer.cubeportfolio({
//
//      animationType: 'flipOut',
//
//      gapHorizontal: 45,
//
//      gapVertical: 30,
//
//      gridAdjustment: 'responsive',
//
//      caption: 'overlayBottomReveal',
//
//      displayType: 'lazyLoading',
//
//      displayTypeSpeed: 100,
//
//      // lightbox
//      lightboxDelegate: '.cbp-lightbox',
//      lightboxGallery: true,
//      lightboxTitleSrc: 'data-title',
//      lightboxShowCounter: true,
//
//      // singlePage popup
//      singlePageDelegate: '.cbp-singlePage',
//      singlePageDeeplinking: true,
//      singlePageStickyNavigation: true,
//      singlePageShowCounter: true,
//      singlePageCallback: function (url, element) {
//
//        // to update singlePage content use the following method: this.updateSinglePage(yourContent)
//        var t = this;
//
//        $.ajax({
//          url: url,
//          type: 'GET',
//          dataType: 'html',
//          timeout: 5000
//        })
//            .done(function (result) {
//              t.updateSinglePage(result);
//            })
//            .fail(function () {
//              t.updateSinglePage("Error! Please refresh the page!");
//            });
//
//      },
//
//      // single page inline
//      singlePageInlineDelegate: '.cbp-singlePageInline',
//      singlePageInlinePosition: 'above',
//      singlePageInlineShowCounter: true,
//      singlePageInlineCallback: function (url, element) {
//        // to update singlePage Inline content use the following method: this.updateSinglePageInline(yourContent)
//      }
//    });
//
//    // add listener for filters click
//    filtersContainer.on('click', '.cbp-filter-item', function (e) {
//
//      var me = $(this);
//
//      // get cubeportfolio data and check if is still animating (reposition) the items.
//      if (!$.data(gridContainer[0], 'cubeportfolio').isAnimating) {
//        me.addClass('cbp-filter-item-active').siblings().removeClass('cbp-filter-item-active');
//      }
//
//      // filter the items
//      gridContainer.cubeportfolio('filter', me.data('filter'), function () {
//      });
//
//    });
//
//
//    // add listener for inline filters click
//    gridContainer.on('click', '.cbp-l-grid-projects-inlineFilters', function (e) {
//
//      var filter = $(this).data('filter');
//
//      // get cubeportfolio data and check if is still animating (reposition) the items
//      if (!$.data(gridContainer[0], 'cubeportfolio').isAnimating) {
//        filtersContainer.children().removeClass('cbp-filter-item-active').filter('[data-filter="' + filter + '"]').addClass('cbp-filter-item-active');
//      }
//
//      // filter the items
//      gridContainer.cubeportfolio('filter', filter, function () {
//      });
//
//    });
//
//
//    // activate counters
//    gridContainer.cubeportfolio('showCounter', filtersContainer.find('.cbp-filter-item'));
//  }
//
//
//  $(document).ready(ready);
//  $(document).on('page:load', ready);
//})(jQuery, window, document);
//
//// See the code implemented in full @ http://scriptpie.com/cubeportfolio/website/index.php?q=juicy-projects