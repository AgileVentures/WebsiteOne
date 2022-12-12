describe('Documents', function(){
  beforeEach(function(){
    setFixtures(sandbox({id: 'something'}));
    appendSetFixtures('<a id="revisions-anchor" href="#">Revisions</a><div id="revisions" style="display:none"><br/>This is <b>first</b> revision</div>');
    reloadModule('Documents');
    WebsiteOne.Documents.init();
    jQuery.fx.off = true;
  });

  it('prevents refreshing the page after link gets clicked', function() {
    var submitSpy = jasmine.createSpy('submitSpy')
    $(document).on('submit', submitSpy);

    $('#revisions-anchor').trigger('click');

    expect(submitSpy).not.toHaveBeenCalled();
  });

  it('shows revisions div after Revisions link is clicked', function(){
    $('#revisions-anchor').trigger('click');
    expect($('#revisions')).toBeVisible();
  });

  it('hides revisions div after Revisions is clicked twice', function(){
    $('#revisions-anchor').trigger('click');
    $('#revisions-anchor').trigger('click');
    expect($('#revisions')).toBeHidden();
    jQuery.fx.off = false
  });
});
