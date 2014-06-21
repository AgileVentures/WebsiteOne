describe('events', function() {

  it('loads api library for hangouts', function() {
    expect(window.WebsiteOne.renderHangoutButton).toBeDefined();
  });

  it('calls #renderHangoutButton', function() {
    reloadScript('events.js');
    spyOn(WebsiteOne, 'renderHangoutButton');

    WebsiteOne.Events.init();
    expect(WebsiteOne.renderHangoutButton).toHaveBeenCalled();
  });

});
