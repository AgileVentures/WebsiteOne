@EventsUtils = ->

  @ajaxRequest = =>
    if window.location.href is @href
      $.get @href, @updateHangoutsData
    else
      clearInterval @intervalId

  @updateHangoutsData = (data)=>
    if data.match 'hangouts-details-well'
      clearInterval @intervalId

      $('#hg-management').html data
      $('.readme-link').popover {trigger: 'focus'}
      WebsiteOne.renderHangoutButton()

  @init = =>
    @href = window.location.href
    @intervalId = setInterval @ajaxRequest, 10000
    $('.readme-link').popover {trigger: 'focus'}

  return true

(new @EventsUtils).init()
