$('#collapse0').toggle();
$('.user-popover').popover({trigger: 'hover'});
$('#btn-hg-toggle').click(function (){
   $('.live-hangouts .collapse').collapse('toggle');
});
$('.panel-heading').click(function(){
  if($(event.toElement).prop('tagName') !== 'A'){
    $(this).closest('.panel').find('.panel-collapse').toggleClass('in');
  }
});
