this.EventsUtils = function() {
  this.ajaxRequest = function() {
    var _this = this;
    if (window.location.href === _this.href) {
      return $.get(_this.href, _this.updateHangoutsData);
    } else {
      clearInterval(_this.intervalId);
    }
  };

  this.updateHangoutsData = function(data) {
    var _this = this;
    if (data.match('hangouts-details-well')) {
      clearInterval(_this.intervalId);

      $('#hg-management').html(data);
      $('.readme-link').popover({ trigger: 'focus' });
      WebsiteOne.renderHangoutButton();
    }
  };

  this.init = function() {
    var _this = this;
    _this.href = window.location.href;
    /** _this.intervalId = setInterval(_this.ajaxRequest, 10000);*/

    $('.readme-link').popover({ trigger: 'focus' });
  };
};

(new this.EventsUtils).init();
