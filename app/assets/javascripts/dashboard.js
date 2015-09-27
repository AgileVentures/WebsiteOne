$('#tabs a').click(function (e) {
    var scrollHeight = $(document).scrollTop();
    $(this).tab('show');
    setTimeout(function () {
        $(window).scrollTop(scrollHeight);
    }, 5);
});
