//= require ./wso

WSO.define('AccordionCollapse', function() {

  var collapsedClass = 'fa-caret-down',
      expandedClass = 'fa-caret-right';

  return {
    init: function() {
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
    }
  }
});
