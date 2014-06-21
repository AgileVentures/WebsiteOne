describe('events', function() {

  it('defines Events module for WebsiteOne', function() {
    expect(window.WebsiteOne.Events).toBeDefined();
  });

  it('calls #renderHangoutButton', function() {
    reloadScript('events.js');
    spyOn(WebsiteOne, 'renderHangoutButton');

    WebsiteOne.Events.init();
    expect(WebsiteOne.renderHangoutButton).toHaveBeenCalled();
  });

});
