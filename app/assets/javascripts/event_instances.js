this.EventInstancesUtils = function() {
  this.bindEvents = function() {
    $('.btn-hg-join, .btn-hg-watch').click(function() {
      event.stopPropagation();
    });

    $('.btn-hg-join.disable').unbind().click(function() {
      event.preventDefault();
      event.stopPropagation();
    });

    return $('#hg-container').on('click', '.panel-heading', function() {
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

    if ($('#hg-container + .pagination').length) {
      $(window).scroll(function() {
        var url = $('.pagination a[rel="next"]').attr('href');
        if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 450) {
          $('.pagination').text("Please Wait...");
          return $.getScript(url);
        }
      });
      return $(window).scroll();
    }
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
