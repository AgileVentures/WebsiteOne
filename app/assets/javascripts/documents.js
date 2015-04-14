$(document).ready(function() {
  $('#revisions-anchor').on('click', function(e){
    e.preventDefault();
    $('#revisions').slideToggle('slow');
    $("#arrow").toggleClass("fa-arrow-up").toggleClass("fa-arrow-down");
  });
  return false;
});
