//= require medium-editor

WebsiteOne.define('StaticPages', function() {
    return {
        init: function() {
            var editor = new MediumEditor('.editable', {
                placeholder: {
                    /* This example includes the default options for placeholder,
                        if nothing is passed this is what it used */
                    text: 'Type your text',
                    hideOnClick: true
                }
            }
        };
    }
});