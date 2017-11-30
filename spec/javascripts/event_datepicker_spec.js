describe('eventDatePicker', function(){

  beforeEach(function () {
    // Michael is concerned that fixture is large and involved and creating too complex a seam
    loadFixtures('event_datepicker.html');
    eventDatepicker.init();
  });

  var set_event_repeats_to_weekly = function(){
    $('#event_repeats').val('weekly')
    $('#event_repeats').trigger('change')
  }

  var set_event_repeat_ends_to_never = function(){
    $('#event_repeat_ends_string').val('never')
    $('#event_repeat_ends_string').trigger('change')
  }

  it('hides event repeat options by default', function () {
    expect($('#repeats_options')).toBeHidden();
    expect($('#repeats_weekly_options')).toBeHidden();
    expect($('.event_option')).toBeHidden();
  });

  it('shows event repeat options when event is set to repeat', function () {
    set_event_repeats_to_weekly();
    expect($('#repeats_options')).not.toBeHidden();
    expect($('#repeats_weekly_options')).not.toBeHidden();
    expect($('.event_option')).not.toBeHidden();
  });

  it('shows event repeat optional ending when event is set to end', function () {
    set_event_repeats_to_weekly();
    expect($('#repeat_ends_on_label')).not.toBeHidden();
    expect($('#repeat_ends_on')).not.toBeHidden();
  });

  it('hides event repeat optional ending when event is set to never end', function () {
    set_event_repeats_to_weekly();
    set_event_repeat_ends_to_never();
    expect($('#repeat_ends_on_label')).toBeHidden();
    expect($('#repeat_ends_on')).toBeHidden();
  });

});