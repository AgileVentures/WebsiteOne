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

    $(".dropdown-menu a").click(function() {
        $(this).closest(".dropdown").find("[data-toggle='dropdown']").dropdown("toggle");
    });
    $("#attendance_checkbox").change( function (){
        $(".form-class").submit();
    });
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