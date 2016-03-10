describe('Events', function () {

    beforeEach(function () {
        setFixtures('<div class="event-row" id="details_1">'+
                    '<div class="row">'+
                    '<div class="col-lg-9 col-xs-12 col-sm-9">'+
                    '<div class="event-title"><a href="event_loc">Awesome Event</a></div>'+
                    '</div>'+
                    '</div>'+
                    '</div>');
        events.makeRowBodyClickable();
    });

    it('is clickable anywhere in the row', function () {
        var spy = spyOn(browserAdapter, 'jumpTo');
        $('.event-row').first().trigger('click');
        expect(spy).toHaveBeenCalledWith('http://' + window.location.host + '/event_loc');
    });

});
