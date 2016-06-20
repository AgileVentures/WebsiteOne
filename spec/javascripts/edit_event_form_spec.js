describe('editEventForm', function () {

    beforeEach(function () {
        setFixtures('<div>'+
            '<input type="text" name="start_date" id="start_date" value="2016-05-27" style="width:auto;" class="form-control datepicker">'+
            '<input type="hidden" name="next_date" id="next_date" value="2016-05-27" style="width:auto;" class="form-control datepicker">'+
            '</div>'+
            '<div>'+
            '<input type="text" name="start_time" id="start_time" value="10:27 pm" style="width:auto;" class="form-control timepicker">'+
            '</div>'+
            '<div>'+
            '<select id="start_time_tz">' +
            '<option value="World/Someplace" selected="selected">World/Someplace</option>'+
            '<option value="Capybara/GreenSwamp">Capybara/GreenSwamp</option>'+
            '<option value="DisneyWorld/Aladdin">DisneyWorld/Aladdin</option>'+
            '</select>'+
            '</div>');
    });

    it('sets the timezone properly', function () {
        spyOn(timeZoneUtilities,'detectUserTimeZone').and.returnValue('Capybara/GreenSwamp');
        expect($("#start_time_tz").val()).toEqual("World/Someplace");
        editEventForm.handleUserTimeZone();
        expect($("#start_time_tz").val()).toEqual("Capybara/GreenSwamp");
    });

    it('adjusts the time properly', function () {
        spyOn(timeZoneUtilities,'detectUserTimeZone').and.returnValue('Europe/London');
        editEventForm.handleUserTimeZone();
        expect($('#start_time').val()).toEqual('11:27 PM');
    });

    it('adjusts the date properly', function () {

        spyOn(timeZoneUtilities,'detectUserTimeZone').and.returnValue('Europe/Kiev');
        editEventForm.handleUserTimeZone();
        expect($('#start_date').val()).toEqual('2016-05-28');
    });

});
