$(document).on('ready page:load', function() {
    $('#google-search-dropdown').on('show.bs.dropdown', function() {
        $('#google_search i').removeClass('fa-search').addClass('fa-times');
        $('#nav').css('z-index', 'inherit')
    });
    $('#google-search-dropdown').on('shown.bs.dropdown', function() {
        $("#gsc-i-id1").focus();
    });
    $('#google-search-dropdown').on('hidden.bs.dropdown', function() {
        $('#google_search i').removeClass('fa-times').addClass('fa-search');
        $('#nav').css('z-index', 0)
    });
    return false;
});
