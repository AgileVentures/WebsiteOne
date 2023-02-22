describe('eventDatePicker', function(){

  beforeEach(function () {
    // Michael is concerned that fixture is large and involved and creating too complex a seam
    var html = `
    <div class="form-group">
        <label class="control-label" for="event_repeats">Repeats</label>
        <select default="default" class="form-control" name="event[repeats]" id="event_repeats"><option value="never">never</option>
            <option value="weekly">weekly</option></select>
        <fieldset class="event_option" id="repeats_weekly_options" style="display: none;">
            <div class="control-group">
                <label class="control-label">Each</label>
                <div class="controls">
                    <label class="checkbox inline" for="event_repeats_weekly_each_days_of_the_week_monday">
                        <input type="checkbox" name="event[repeats_weekly_each_days_of_the_week][]" id="event_repeats_weekly_each_days_of_the_week_monday" value="monday">
                        Monday
                    </label>          <label class="checkbox inline" for="event_repeats_weekly_each_days_of_the_week_tuesday">
                    <input type="checkbox" name="event[repeats_weekly_each_days_of_the_week][]" id="event_repeats_weekly_each_days_of_the_week_tuesday" value="tuesday">
                    Tuesday
                </label>          <label class="checkbox inline" for="event_repeats_weekly_each_days_of_the_week_wednesday">
                    <input type="checkbox" name="event[repeats_weekly_each_days_of_the_week][]" id="event_repeats_weekly_each_days_of_the_week_wednesday" value="wednesday">
                    Wednesday
                </label>          <label class="checkbox inline" for="event_repeats_weekly_each_days_of_the_week_thursday">
                    <input type="checkbox" name="event[repeats_weekly_each_days_of_the_week][]" id="event_repeats_weekly_each_days_of_the_week_thursday" value="thursday">
                    Thursday
                </label>          <label class="checkbox inline" for="event_repeats_weekly_each_days_of_the_week_friday">
                    <input type="checkbox" name="event[repeats_weekly_each_days_of_the_week][]" id="event_repeats_weekly_each_days_of_the_week_friday" value="friday">
                    Friday
                </label>          <label class="checkbox inline" for="event_repeats_weekly_each_days_of_the_week_saturday">
                    <input type="checkbox" name="event[repeats_weekly_each_days_of_the_week][]" id="event_repeats_weekly_each_days_of_the_week_saturday" value="saturday">
                    Saturday
                </label>          <label class="checkbox inline" for="event_repeats_weekly_each_days_of_the_week_sunday">
                    <input type="checkbox" name="event[repeats_weekly_each_days_of_the_week][]" id="event_repeats_weekly_each_days_of_the_week_sunday" value="sunday">
                    Sunday
                </label>      <input value="1" type="hidden" name="event[repeats_every_n_weeks]" id="event_repeats_every_n_weeks">
                    <input type="hidden" name="event[repeats_weekly_each_days_of_the_week][]" id="event_repeats_weekly_each_days_of_the_week_" value="">
                </div>
            </div>
        </fieldset>

    </div>

    <div class="form-group event_option" id="repeats_options" style="display: block;">
        <label class="control-label" for="event_repeat_ends_string">Repeat ends</label>
        <select class="form-control" name="event[repeat_ends_string]" id="event_repeat_ends_string"><option selected="selected" value="on">on</option>
            <option value="never">never</option></select>
    </div>

    <div class="form-group event_option repeat_ends_on" style="display: none;">
        <label class="control-label" id="repeat_ends_on_label" for="repeat_ends_on">End Date</label>
        <input type="text" name="repeat_ends_on" id="repeat_ends_on" value="" style="width:auto;" class="form-control datepicker">
    </div>
    `
    setFixtures(html);
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

  it('set repeat-ends-on to an empty string when it is set and changed to never', function () {
    set_event_repeats_to_weekly();
    $("#repeat_ends_on").val('2019-08-01')
    set_event_repeat_ends_to_never();
    expect($('#repeat_ends_on')).toBeHidden();
    expect($('#repeat_ends_on_label')).toBeHidden();
    expect($('#repeat_ends_on').val()).toEqual('');
  });
});
