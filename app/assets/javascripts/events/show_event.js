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

    toggleAttendance: function(){
        $("#attendance_checkbox").change( function (){
            $(".form-class").submit();
          });
    }
};
