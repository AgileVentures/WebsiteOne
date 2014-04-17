describe('AccordionCollapse module', function() {
  beforeEach(function() {
    setFixtures('<a class="collapse-button"><i class="fa-caret-down"></i></a>');

    reloadScript('accordion_collapse.js');

    $(document).trigger('page:load');
  });

  it('should create a module called "AccordionCollapse"', function() {
    expect(window.WSO.AccordionCollapse).toBeDefined();
  });

  it('should change class when clicked once', function() {
    $('.collapse-button').click();
    expect($('.collapse-button :first-child').hasClass('fa-caret-right')).toBeTruthy();
  });

  it('should not change the class when clicked twice', function() {
    $('.collapse-button').click();
    $('.collapse-button').click();
    expect($('.collapse-button :first-child').hasClass('fa-caret-down')).toBeTruthy();
  });
});
