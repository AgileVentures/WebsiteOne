(function() {
  var responseData = '';
  var initHangouts = function() {
    $('#collapse0').toggle();
    WebsiteOne.toggleCaret($('#collapse0').closest('.panel').find('i.fa'));

    $('.user-popover').popover({trigger: 'hover'});

    $('.btn-hg-join, .btn-hg-watch').click(function (){
      event.stopPropagation();
    });

    $('.btn-hg-join.disable').unbind().click(function (){
      event.preventDefault();
      event.stopPropagation();
    });

    $('.panel-heading').click(function(){
      $(this).closest('.panel').find('.panel-collapse').slideToggle();
      WebsiteOne.toggleCaret($(this).find('i.fa'));
    });
  };

  $('#btn-hg-toggle').click(function (){
    $('.live-hangouts .collapse').slideToggle();
    WebsiteOne.toggleCaret($('.panel').find('i.fa'));
  });

  var refreshHangouts = function() {
    $.get(window.location.href, function(data) {
      if(responseData !== data) {
        responseData = data;
        $('#hg-container').html(data);
        initHangouts();
      }
    })
  };

  initHangouts();
  setInterval(refreshHangouts, 10000);
})();
