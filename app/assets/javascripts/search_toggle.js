$(document).ready(function() {
    $("#google_search").click(function() {
        // Replace search icon with close
        if($('#google-search-wrapper').css('display') == "none") {
            $('#google_search i').removeClass('fa-search').addClass('fa-times');
            $('#nav').css('z-index', 1000);
        } else {
            $('#google_search i').removeClass('fa-times').addClass('fa-search');
            $('#nav').css('z-index', 0);
        }

        $('#google-search-wrapper').fadeToggle(200, function() {
            $("#gsc-i-id1").focus();
        });
    });
    return false;
});
