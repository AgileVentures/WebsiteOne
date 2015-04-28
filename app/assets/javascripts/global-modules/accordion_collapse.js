WebsiteOne.define('AccordionCollapse', function() {

  WebsiteOne.toggleCaret = function(child) {
    var collapsedClass = 'fa-caret-down';
    var expandedClass = 'fa-caret-right';

    if (child.hasClass(collapsedClass)) {
      child.removeClass(collapsedClass).addClass(expandedClass);
    } else if (child.hasClass(expandedClass)) {
      child.removeClass(expandedClass).addClass(collapsedClass);
    }
  };

  return {
    init: function() {
      $('.collapse-button').on('click', function() {
        var child = $(this).find('i.fa');
        WebsiteOne.toggleCaret(child);
      });
    }
  }
});
