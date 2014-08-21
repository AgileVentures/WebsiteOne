$('.readme-link').popover {trigger: 'focus'}

refreshHangoutsManagement = ->
  $.get window.location.href, (data)->
    if data.match('hangouts-details-well')
      $('#hg-management').html data
      WebsiteOne.renderHangoutButton()
      $('.readme-link').popover {trigger: 'focus'}
      clearInterval(intervalId)

intervalId = setInterval(refreshHangoutsManagement, 10000);
