//= require medium-editor

window._init_editor = window._init_editor||[];
!function(){
    var editor = new MediumEditor('.editable', {
        placeholder: {
            /* This example includes the default options for placeholder,
                if nothing is passed this is what it used */
            text: 'Type your text',
            hideOnClick: true
        }
    })
}();

