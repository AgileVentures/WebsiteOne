import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "start", "start_tz"]
  connect() {
    if (this.start_tzTarget) {
      $('#start_time_tz').setToUserTimeZone(moment.tz.guess());
    }
    if (this.startTarget) {
      var normalized_start_date_time = moment.utc($('#start_datetime').val(), "YYYY-MM-DDThh:mm");
      var local_start_date_time = normalized_start_date_time.tz(moment.tz.guess());
      $('#start_datetime').val(local_start_date_time.format("YYYY-MM-DDTHH:mm"));
      if (normalized_start_date_time.toDate().getUTCDate() !== normalized_start_date_time.toDate().getDate())
          var daysOfWeek = document.querySelectorAll('#daysOfWeek>label>input')
          if (daysOfWeek) {
            var arrayOfdays = []
            daysOfWeek.forEach(function (checkBox) { arrayOfdays.push(checkBox.checked) })
            var tmp;
            if (normalized_start_date_time._offset > 0) {
                tmp = arrayOfdays.pop()
                arrayOfdays.unshift(tmp)
            } else {
                tmp = arrayOfdays.shift()
                arrayOfdays.push(tmp)
            }
            daysOfWeek.forEach(function (checkBox, index) { checkBox.checked = arrayOfdays[index] })
        }
    }
    this.repeats();
    this.repeat_ends_on();
  }
  repeats() {
    console.log('in events_repeats_controller repeats')
    $('.event_option').hide();
    switch ($('#event_repeats').val()) {
        case 'never':
            // Nothing
            break;
        case 'biweekly':    
        case 'weekly':
            $('#repeats_options').show();
            $('#repeats_weekly_options').show();
            $('.event_option').show();
            this.repeat_ends_on();
            break;
    }
  }
  repeat_ends_on(){
    console.log('in events_repeats_controller repeat_ends_on')
    switch ($('#event_repeat_ends_string').val()) {
      case 'never':
          $('#repeat_ends_on_label').hide();
          $('#event_repeat_ends_on_1i').hide();
          $('#event_repeat_ends_on_2i').hide();
          $('#event_repeat_ends_on_3i').hide();
          break;
      case 'on':
          $('#repeat_ends_on_label').show();
          $('#event_repeat_ends_on_1i').show();
          $('#event_repeat_ends_on_2i').show();
          $('#event_repeat_ends_on_3i').show();
          break;
    }
  }
}

jQuery.fn.setToUserTimeZone = function (timezone) {
  var regEx = new RegExp(timezone);

  $('option', $(this[0])).each(function (index, option) {

      var $option = $(option);

      if ($option.html().match(regEx)) {
          $option.prop({ selected: 'true' });
          return false;
      }
  });
};