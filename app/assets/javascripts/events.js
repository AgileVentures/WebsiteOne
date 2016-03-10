this.EventsUtils = function () {


    this.ajaxRequest = function () {
        var _this = this;
        if (window.location.href === _this.href) {
            return $.get(_this.href, _this.updateHangoutsData);
        } else {
            clearInterval(_this.intervalId);
        }
    };

    this.updateHangoutsData = function (data) {
        var _this = this;
        if (data.match('hangouts-details-well')) {
            clearInterval(_this.intervalId);

            $('#hg-management').html(data);
            $('.readme-link').popover({trigger: 'focus'});
            WebsiteOne.renderHangoutButton();
        }
    };

    toggleLinkText = function (object) {
        var object = object;
        if ($(object).children("a").text() == 'Edit hangout link') {
            $(object).children("a").text('Hide edit controls');
        } else {
            $(object).children("a").text('Edit hangout link');
        }
    };


    this.init = function () {
        var _this = this;
        _this.href = window.location.href;
        /** _this.intervalId = setInterval(_this.ajaxRequest, 10000);*/

        $('.readme-link').popover({trigger: 'focus'});

        $("li[role='edit_hoa_link']").click(function () {
            $(".dropdown-beside-HOA").removeClass("open");
            toggleLinkText(this);
        });

        $('#hoa_link_cancel').click(function () {
            var element = $("li[role='edit_hoa_link']");
            toggleLinkText(element);
        });
    };
};

$( document ).ready(function() {
    $('.event-row').css('cursor', 'pointer');
    $('.event-row').on('click', function(event){
        var clicked_row = $(this);
        var href = clicked_row.find('.event-title a')[0].href;
        window.location.href = href;
    });
});