responseData = ''

$('#btn-hg-toggle').click ->
  $('.live-hangouts .collapse').slideToggle()
  WebsiteOne.toggleCaret $('.panel').find('i.fa')

initHangouts = ->
  $('#collapse0').toggle()
  WebsiteOne.toggleCaret $('#collapse0').closest('.panel').find('i.fa')

  $('.user-popover').popover {trigger: 'hover'}

  $('.btn-hg-join, .btn-hg-watch').click -> event.stopPropagation()

  $('.btn-hg-join.disable').unbind().click ->
    event.preventDefault()
    event.stopPropagation()

  $('.panel-heading').click ->
    $(this).closest('.panel').find('.panel-collapse').slideToggle()
    WebsiteOne.toggleCaret $(this).find('i.fa')

refreshHangouts = ->
  $.get window.location.href, (data)->
    if responseData isnt data
      responseData = data
      $('#hg-container').html data
      initHangouts()

initHangouts()
setInterval(refreshHangouts, 10000)
