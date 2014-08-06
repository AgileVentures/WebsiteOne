WebsiteOne.define('Hookups', function () {

    (function ($) {
        $.fn.toggleDisabled = function () {
            return this.each(function () {
                this.disabled = !this.disabled;
            });
        };
    })(jQuery);

    function toggle_event_cancel() {
        $('#form-hookup-create').slideToggle();
        return false;
    }

    function toggle_event_immediate() {
        $('#form-hookup-create').slideToggle();
        return false;
    }

    function setup() {
        $('#btn-hookup-new').show();
        $('#btn-hookup-new').click(toggle_event_immediate);
        $('#btn-cancel-new').click(toggle_event_cancel);
    }

    return {
        init: setup}
});