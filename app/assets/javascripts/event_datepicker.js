var EventScheduler = {
    init: function () {
        $('.datepicker').datepicker({
            format: 'yyyy-mm-dd'
        });
        $('.timepicker').timepicker();
        $('#event_repeats').on('change', this.toggle_event_options);
        $('#event_repeat_ends_string').on('change', this.toggle_repeat_ends_on);
        this.toggle_event_options();
        this.toggle_repeat_ends_on();
    },

    toggle_event_options: function () {
        $('.event_option').hide();
        switch ($('#event_repeats').val()) {
            case 'never':
                // Nothing
                break;

            case 'weekly':
                $('#repeats_options').show();
                $('#repeats_weekly_options').show();
                break;
        }
    },

    toggle_repeat_ends_on: function () {
        switch ($('#event_repeat_ends_string').val()) {
            case 'never':
                $('#repeat_ends_on_label').hide();
                $('#repeat_ends_on').hide();
                break;
            case 'on':
                $('#repeat_ends_on_label').show();
                $('#repeat_ends_on').show();
                break;
        }
    }
}
$(document).on('ready page:load', function () {
    EventScheduler.init();
});