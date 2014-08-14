WebsiteOne.define('Hookups', function () {

    function toggle_event_cancel() {
        $('#form-hookup-create').slideToggle();
        $('btn-hookup-new').disabled = false;
        return false;
    }

    function toggle_event_immediate() {
        $('#form-hookup-create').slideToggle();
        $('btn-hookup-new').disabled = true;
        return false;
    }

    function setup() {
        $('#btn-hookup-new').click(toggle_event_immediate);
        $('#btn-cancel-new').click(toggle_event_cancel);
        $('btn-hookup-new').disabled = false;
    }

    return {
        init: setup}
});