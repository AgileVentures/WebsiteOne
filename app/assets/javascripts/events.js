var browserAdapter = {
    jumpTo : function (url) {
        window.location.assign(url);
    }
};

var events = {
    makeRowBodyClickable : function () {
        $('.event-row').css('cursor', 'pointer');
        $('.event-row').on('click', function (event) {
            var clicked_row = $(this);
            var href = clicked_row.find('.event-title a')[0].href;
            browserAdapter.jumpTo(href);
        });
    },
    addToCalendar: function () {
        /* Any click not the calendar link will hide the calendar links div */
        $(document).click(function(e){
            if(e.currentTarget.activeElement.id === 'calendar_link') {
                $("#calendar_links").show();
            } else {
                $("#calendar_links").hide();
            }
        });
    }
};

var jitsi_events = {
    showIframe: function() {
        $('#btn-jitsi').click(function() {
            var iframe_container = document.getElementById('meet-container');
            var iframe = document.getElementById('meet');
            iframe.src = iframe.getAttribute('hidden_src');
            iframe_container.style.display = 'block';       
        })
    },
    
    startRecording: function() {
        $('#jitsi-record').click(function() {
            $.ajax({type: 'POST',
                url: $(this).attr('href'),
                timeout: 30000,
                success: function(res) {
                    alert('Start jitsi live stream with this key: ' +
                        res.stream_name);
                },
                error: function(xhrObj, textStatus, exception) {
                    alert('Error!'); 
                }
            });            
        })
    }
}

$(document).ready(function () {
    events.makeRowBodyClickable();
    events.addToCalendar();
    editEventForm.handleUserTimeZone();
    showEvent.showUserTimeZone();
    jitsi_events.showIframe();
    jitsi_events.startRecording();
});