(function() {
  $('#collapse0').toggle();
  WebsiteOne.toggleCaret($('#collapse0').closest('.panel').find('i.fa'));

  $('.user-popover').popover({trigger: 'hover'});

  $('#btn-hg-toggle').click(function (){
    $('.live-hangouts .collapse').collapse('toggle');
  });

  $('.panel-heading').click(function(){
    if($(event.toElement).prop('tagName') !== 'A'){
      $(this).closest('.panel').find('.panel-collapse').slideToggle();
      WebsiteOne.toggleCaret($(this).find('i.fa'));
    }
  });
})();
