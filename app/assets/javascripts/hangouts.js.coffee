do @HangoutsUtils = ->

  @bindEvents = ->
    $('#collapse0').slideDown()
    WebsiteOne.toggleCaret $('#collapse0').closest('.panel').find('i.fa')

    $('.user-popover').popover {trigger: 'hover'}
    $('.btn-hg-join, .btn-hg-watch').click -> event.stopPropagation()

    $('.btn-hg-join.disable').unbind().click ->
      event.preventDefault()
      event.stopPropagation()

    $('.panel-heading').click ->
      $(this).closest('.panel').find('.panel-collapse').slideToggle()
      WebsiteOne.toggleCaret $(this).find('i.fa')

  @init = =>
    @href = window.location.href
    @intervalId = setInterval(@ajaxRequest, 10000)

    @bindEvents()

    $('#btn-hg-toggle').click ->
      $('.live-hangouts .collapse').slideToggle()
      WebsiteOne.toggleCaret $('.panel').find('i.fa')

  @updateHangoutsData = (data)=>
    data = data.trim()
    if data isnt @container
      $('#hg-container').html data if @container
      @container = data
      @bindEvents()

  @ajaxRequest = ->
    if window.location.href is @href
      $.get href, @updateHangoutsData
    else
      clearInterval @intervalId

  @init()
  return true
