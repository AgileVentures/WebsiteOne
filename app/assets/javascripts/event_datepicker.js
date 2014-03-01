$(function() {
  function ready() {
    $( ".datepicker" ).datepicker({
      format: 'yyyy-mm-dd'
    });
    $('.timepicker').timepicker();

    var toggle_repeats_yearly_on = function () {
      if ($('#event_repeats_yearly_on').is(':checked')) {
        $('#event_repeats_yearly_on_options').show();
      } else {
        $('#event_repeats_yearly_on_options').hide();
      }
    }
    toggle_repeats_yearly_on();
    $('#event_repeats_yearly_on').on('change', function () {
      toggle_repeats_yearly_on();
    });
    var toggle_event_times = function () {
      if ($('#event_is_all_day').is(':checked')) {
        $('.event_time').hide();
      } else {
        $('.event_time').show();
      }
    }
    toggle_event_times();
    $('#event_is_all_day').on('change', function () {
      toggle_event_times();
    });
    var toggle_event_options = function () {
      $('.event_option').hide();
      switch ($('#event_repeats').val()) {
        case 'never':
          // Nothing
          break;
        case 'daily':
          $('#repeats_options').show();
          $('#repeats_daily_options').show();
          break;
        case 'weekly':
          $('#repeats_options').show();
          $('#repeats_weekly_options').show();
          break;
        case 'monthly':
          $('#repeats_options').show();
          $('#repeats_monthly_options').show();
          break;
        case 'yearly':
          $('#repeats_options').show();
          $('#repeats_yearly_options').show();
          break;
      }
    }
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
    }
    toggle_repeat_ends_on();
    $('#event_repeat_ends').on('change', function () {
      toggle_repeat_ends_on();
    });
    var toggle_repeats_monthly = function () {
      switch ($('#event_repeats_monthly').val()) {
        case 'each':
          $('#event_repeats_monthly_each').show();
          $('#event_repeats_monthly_on').hide();
          break;
        case 'on':
          $('#event_repeats_monthly_each').hide();
          $('#event_repeats_monthly_on').show();
          break;
      }
    }
    toggle_repeats_monthly();
    $('#event_repeats_monthly').on('change', function () {
      toggle_repeats_monthly();
    });
  }

  $(document).ready(ready);
  $(document).on('page:load', ready);
});