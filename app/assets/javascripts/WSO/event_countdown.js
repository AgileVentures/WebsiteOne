//= require ./wso

WSO.define('EventCountdown', function() {
  var countdownClock, eventName, eventTime, eventUrl, textToAppend;

  function format(num) {
    return (num < 10) ? '0' + num : num.toString();
  }

  function update() {
    var timeToEvent = eventTime - new Date(),
        timeInSeconds = Math.floor(timeToEvent / 1000),
        timeInMins = Math.floor(timeInSeconds / 60),
        timeInHours = Math.floor(timeInMins / 60);

    if (timeInSeconds <= 0) {
      countdownClock.html('<a href="' + eventUrl + '">' + eventName + '</a> has started');
    } else {
      var tmp = '<p>';
      if (timeInHours > 0) {
        tmp += format(timeInHours) + ':';
      }

      countdownClock.html(tmp + format(timeInMins % 60) +
          ':' + format(timeInSeconds % 60) +
          textToAppend);
      setTimeout(update, 1000);
    }
  }

  function init() {
    clearTimeout(update);

    countdownClock = $('#next-event');
    if (countdownClock.length > 0) {
      eventTime = Date.parse(countdownClock.data('event-time'));
      eventUrl = countdownClock.data('event-url');
      eventName = countdownClock.data('event-name');
      textToAppend = ' to <a href="' + eventUrl + '">' + eventName + '</a></p>';

      update();
    } else {
      eventName = null;
      eventTime = null;
      eventUrl = null;
      textToAppend = null;
    }
  }

  return {
    init: init,
    update: update,
    format: format,
    getCountdownClock: function() { return countdownClock; }
  };
});