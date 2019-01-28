(function() {
  $(function() {
    return $('[data-behavior~=ajax-spin').on('click', function() {
      var target;
      target = $(this).data('target');
      return $(target).spin({
        lines: 12, // The number of lines to draw
        length: 7, // The length of each line
        width: 30, // The line thickness
        radius: 100, // The radius of the inner circle
        color: '#EE7335', // #rgb or #rrggbb
        speed: 1, // Rounds per second
        trail: 60, // Afterglow percentage
        shadow: true // Whether to render a shadow
      });
    });
  });

}).call(this);

