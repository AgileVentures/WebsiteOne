var browserAdapter = {
  jumpTo: function (url) {
    window.location.assign(url);
  }
};

var events = {
  makeRowBodyClickable: function () {
    $('.event-row').css('cursor', 'pointer');
    $('.event-row').on('click', function (event) {
      var clicked_row = $(this);
      var href = clicked_row.find('.event-title a')[0].href;
      browserAdapter.jumpTo(href);
    });
  },
  addToCalendar: function () {
    /* Any click not the calendar link will hide the calendar links div */
    $(document).click(function (e) {
      if (e.currentTarget.activeElement.id === 'calendar_link') {
        $("#calendar_links").show();
      } else {
        $("#calendar_links").hide();
      }
    });
  },
  ensure_slack_channel_numbering: function () {
    var slackChannels = $('#event-form').find('.nested-slack-channel-fields');
    if (slackChannels.size() > 1) {
      for (var i = 1; i < slackChannels.size(); i++) {
        $(slackChannels[i]).find('.slack_channel_field_label').html('Slack Channel' + ' (' + (i + 1) + ')')
      }
    }
  }
};

$(document).ready(function () {
  events.makeRowBodyClickable();
  events.addToCalendar();
  editEventForm.handleUserTimeZone();
  showEvent.showUserTimeZone();
  showEvent.toggleDropdown();
  showEvent.toggleAttendance();
  $('#slack_channels').on('cocoon:after-insert', function (e) {
    events.ensure_slack_channel_numbering()
  });
});
