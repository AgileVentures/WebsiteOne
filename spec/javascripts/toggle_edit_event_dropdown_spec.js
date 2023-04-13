describe('Edit event details dropdown toggle', function() {
  beforeEach(function() {
    setFixtures('<div class="dropdown dropdown-beside-HOA pull-right">' +
                  '<button class="btn btn-default dropdown-toggle" type="button" id="actions-dropdown" data-toggle="dropdown">' +
                    'Event Actions<span class="caret"></span>' +
                  '</button>' +
                  '<ul class="dropdown-menu" role="menu" aria-labelledby="actions-dropdown">' +
                    '<li role="edit_hoa_link">' +
                      '<a data-toggle="collapse" data-target="#edit-link-form" role="menuitem" tabindex="-1" data-remote="true" href="#">Edit hangout link</a>' +
                    '</li>' +
                  '</ul>' +
                '</div>' +
                '<div class="col-lg-12 collapse" id="edit-link-form" aria-expanded="false"></div>');
    reloadModule('showEvent');
    WebsiteOne.showEvent.toggleDropdown();
  });

  it('toggles dropdown upon link click', function() {
    var dropdown = $('.dropdown').first()
    $('#actions-dropdown').click();
    expect(dropdown).toHaveClass('open')
    $('li[role="edit_hoa_link"] > a').click();
    expect(dropdown).not.toHaveClass('open');
  });
});
