var showEvent = {
    showUserTimeZone: function () {
        if ($("#local_time").length) {
            $('#local_time').append("&nbsp;" + timeZoneUtilities.detectUserTimeZone());
        }
    },

    toggleDropdown: function() {
      $(".dropdown-menu a").click(function() {
        $(this).closest(".dropdown").find("[data-toggle='dropdown']").dropdown("toggle");
      });
    },

    attendance: function(){
        $("#attendance_checkbox").click( function (){
            $(".form-class").submit();
          });
          /*$('#attendance_checkbox').change(function() {
            if(this.checked) {
                console.log('check')
            }
        });*/
    }
};
