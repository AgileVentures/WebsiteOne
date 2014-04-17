
WSO.define('EventDatePicker', function() {
  function init() {
    $( ".datepicker" ).datepicker({
      format: 'yyyy-mm-dd'
    });
    $('.timepicker').timepicker();

    var toggle_event_options = function () {
      $('.event_option').hide();
      switch ($('#event_repeats').val()) {
        case 'never':
          // Nothing
          break;

        case 'weekly':
          $('#repeats_options').show();
          $('#repeats_weekly_options').show();
          break;
      }
    };

    toggle_event_options();
    $('#event_repeats').on('change', function () {
      toggle_event_options();
    });

    var toggle_repeat_ends_on = function () {
      switch ($('#event_repeat_ends').val()) {
        case 'never':
          $('#event_repeat_ends_on').hide();
          break;
        case 'on':
          $('#event_repeat_ends_on').show();
          break;
      }
    };

    toggle_repeat_ends_on();
    $('#event_repeat_ends').on('change', function () {
      toggle_repeat_ends_on();
    });
  }

  return {
    init: init
  }
});