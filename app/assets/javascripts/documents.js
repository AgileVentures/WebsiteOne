WebsiteOne.define('Documents', function(){
    function init(){
        $('#revisions-anchor').on('click', function(e){
            e.preventDefault();
            $('#revisions').slideToggle('slow');
            $("#arrow").toggleClass("fa-arrow-up").toggleClass("fa-arrow-down");
        });
    }

    return {
        init: init
    };
});
