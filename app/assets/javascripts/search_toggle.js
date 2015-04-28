$(document).ready(function() {
  // Replace search icon with close on toggle

  $('#google-search-dropdown').on('shown.bs.dropdown', function() {
    $('#google_search i').removeClass('fa-search').addClass('fa-times');
    $("#gsc-i-id1").focus();
  });

  $('#google-search-dropdown').on('hidden.bs.dropdown', function() {
    $('#google_search i').removeClass('fa-times').addClass('fa-search');
  });

  return false;
});
