describe('RefreshEventHangout', function () {
    beforeEach(function () {
        this.app = new window.EventsUtils();
        setFixtures(sandbox({id: 'hg-management'}));
    });

    /**it('calls refresh every 10 sec', function() {
      spyOn(window, 'setInterval');
      spyOn(this.app, 'ajaxRequest');
      this.app.init();
      expect(window.setInterval).toHaveBeenCalledWith(this.app.ajaxRequest, 10000);
    });*/

    it('replaces hg-management section', function () {
        spyOn(WebsiteOne, 'renderHangoutButton');
        spyOn(window, 'clearInterval');
        this.app.updateHangoutsData('hangouts-details-well');
        expect(window.clearInterval).toHaveBeenCalledWith(this.app.intervalId);
        expect($('#hg-management').text()).toEqual('hangouts-details-well');
        expect(WebsiteOne.renderHangoutButton).toHaveBeenCalled();
    });

    it('clears refresh repeat if href changes', function () {
        spyOn(window, 'clearInterval');
        this.app.href = 'new_href';
        this.app.ajaxRequest();
        expect(window.clearInterval).toHaveBeenCalledWith(this.app.intervalId);
    });

    //We are not loading the right fixture so these two test will not pass. Blocked by not knowing this files structure
    xit('toggles Edit HOA URL menu item test', function () {
        var element = $("li[role='edit_hoa_link']");
        element.trigger('click');
        var link = element.children("a");
        expect(link).toHaveText('Hide edit controls');
    });

    xit('toggles Edit HOA URL menu item test', function () {
        $("#edit-link-form").collapse('show');
        $('#hoa_link_cancel').trigger('click');
        var link = $("li[role='edit_hoa_link']").children("a");
        expect(link).toHaveText('Edit hangout link');
        expect($("edit-link-form")).toHaveClass('in');
    });


});
