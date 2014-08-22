describe 'RefreshEventHangout', ->
  beforeEach ->
    @app = new window.EventsUtils()
    setFixtures sandbox({ id: 'hg-management' })

  it 'calls refresh every 10 sec', ->
    spyOn @app, 'ajaxRequest'
    jasmine.clock().install()

    @app.init()

    jasmine.clock().tick(10001)
    jasmine.clock().tick(10001)

    expect(@app.ajaxRequest.calls.count()).toEqual(2)

  it 'replaces hg-management section', ->
    spyOn WebsiteOne, 'renderHangoutButton'
    spyOn window, 'clearInterval'

    @app.updateHangoutsData 'hangouts-details-well'

    expect(window.clearInterval).toHaveBeenCalledWith(@app.intervalId)
    expect($('#hg-management').text()).toEqual('hangouts-details-well')
    expect(WebsiteOne.renderHangoutButton).toHaveBeenCalled()

  it 'clears refresh repeat if href changes', ->
    spyOn window, 'clearInterval'
    @app.href = 'new_href'
    @app.ajaxRequest()
    expect(window.clearInterval).toHaveBeenCalledWith(@app.intervalId)
