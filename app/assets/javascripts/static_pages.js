//= require medium-editor

WebsiteOne.define('StaticPages', function() {
    return {
        init: function() {
            var editor = new MediumEditor('.editable', {
                placeholder: {
                    text: 'Type your text',
                    hideOnClick: true
                }
            })
        }
    }
});

