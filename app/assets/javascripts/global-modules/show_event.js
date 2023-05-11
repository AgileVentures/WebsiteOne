WebsiteOne.define('showEvent', function() {
  function showEvent () {
    // this.showUserTimeZone = function () {
    //     // if ($("#local_time").length) {
    //     //     $('#local_time').append("&nbsp;" + WebsiteOne.timeZoneUtilities.detectUserTimeZone());
    //     // }
    // };

    this.toggleDropdown = function() {
      $(".dropdown-menu a").click(function() {
        $(this).closest(".dropdown").find("[data-toggle='dropdown']").dropdown("toggle");
      });
    };

    this.toggleAttendance = function() {
        $("#attendance_checkbox").change( function (){
            $(".form-class").submit();
          });
    };

    this.init = function() {
    };
  };

  return new showEvent();
});
