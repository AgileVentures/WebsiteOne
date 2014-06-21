describe('events', function() {

  beforeEach(function() {
    reloadScript('events.js');
  });

  it('defines Events module for WebsiteOne', function() {
    expect(window.WebsiteOne.Events).toBeDefined();
  });

  it('calls #renderHangoutButton', function() {
    spyOn(WebsiteOne, 'renderHangoutButton');

    WebsiteOne.Events.init();
    expect(WebsiteOne.renderHangoutButton).toHaveBeenCalled();
  });

});
