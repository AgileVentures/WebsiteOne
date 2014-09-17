describe('RefreshHangouts', function() {
  beforeEach(function() {
    setFixtures(sandbox({ id: 'hg-container' }));
    this.app = new window.EventInstancesUtils();
  });

  /**it('calls refresh every 10 sec', function() {
    spyOn(window, 'setInterval');
    spyOn(this.app, 'ajaxRequest');
    this.app.init();
    expect(window.setInterval).toHaveBeenCalledWith(this.app.ajaxRequest, 10000);
  }); */

  it('replaces hg-management section if data has updated', function() {
    spyOn(this.app, 'bindEvents');
    this.app.container = 'old data';
    this.app.updateHangoutsData('new data');
    expect($('#hg-container').text()).toEqual('new data');
    expect(this.app.bindEvents).toHaveBeenCalled();
  });

  it('does not replace hg-management section if data has not updated', function() {
    spyOn(this.app, 'bindEvents');
    this.app.container = 'new data';
    this.app.updateHangoutsData('new data');
    expect($('#hg-container').text()).toEqual('');
  });

  it('clears refresh repeat if href changes', function() {
    spyOn(window, 'clearInterval');
    this.app.href = 'new_href';
    this.app.ajaxRequest();
    expect(window.clearInterval).toHaveBeenCalledWith(this.app.intervalId);
  });

});
