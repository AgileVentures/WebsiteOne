WebsiteOne.define('eventDatepicker', function() {
    function eventDatepicker () {

    this.toggle_event_options = function () {
        $('.event_option').hide();
        switch ($('#event_repeats').val()) {
            case 'never':
                // Nothing
                break;
            
            case 'biweekly':    
            case 'weekly':
                $('#repeats_options').show();
                $('#repeats_weekly_options').show();
                $('.event_option').show();
                WebsiteOne.eventDatepicker.toggle_repeat_ends_on();
                break;
        }
    };

    this.toggle_repeat_ends_on = function () {
        switch ($('#event_repeat_ends_string').val()) {
            case 'never':
                $('#repeat_ends_on_label').hide();
                $('#repeat_ends_on').hide().val('');
                break;
            case 'on':
                $('#repeat_ends_on_label').show();
                $('#repeat_ends_on').show();
                break;
        }
    };

    this.init = function() {
        $('#event_repeats').on('change', this.toggle_event_options);
        $('#event_repeat_ends_string').on('change', this.toggle_repeat_ends_on);
        this.toggle_event_options();
        this.toggle_repeat_ends_on();
    }
    };

    return new eventDatepicker();
});
