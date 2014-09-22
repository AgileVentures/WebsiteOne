this.EventInstancesUtils = function() {
  this.bindEvents = function() {
    $('#collapse0').slideDown();
    WebsiteOne.toggleCaret($('#collapse0').closest('.panel').find('i.fa'));

    $('.user-popover').popover({
      trigger: 'hover'
    });

    $('.btn-hg-join, .btn-hg-watch').click(function() {
      event.stopPropagation();
    });

    $('.btn-hg-join.disable').unbind().click(function() {
      event.preventDefault();
      event.stopPropagation();
    });

    return $('.panel-heading').click(function() {
      $(this).closest('.panel').find('.panel-collapse').slideToggle();
      WebsiteOne.toggleCaret($(this).find('i.fa'));
    });
  };
  this.init = function() {
    var _this = this;
    _this.href = window.location.href;
    /**_this.intervalId = setInterval(_this.ajaxRequest, 10000); */
    _this.bindEvents();

    $('#btn-hg-toggle').click(function() {
      $('.live-hangouts .collapse').slideToggle();
      WebsiteOne.toggleCaret($('.panel').find('i.fa'));
    });
  };

  this.updateHangoutsData = (function(_this) {
    return function(data) {
      data = data.trim();

      if (data !== _this.container) {
        if (_this.container) {
          $('#hg-container').html(data);
          _this.bindEvents();
        }
        _this.container = data;
      }
    };
  })(this);

  this.ajaxRequest = (function(_this) {
    return function() {
      if (window.location.href === _this.href) {
        $.get(_this.href, _this.updateHangoutsData);
      } else {
        clearInterval(_this.intervalId);
      }
    };
  })(this);
};

(new this.EventInstancesUtils).init();
