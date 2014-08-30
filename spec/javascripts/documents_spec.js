describe('Documents', function(){
  beforeEach(function(){
    setFixtures(sandbox({id: 'something'}));
    appendSetFixtures('<a id="revisions-anchor" href="#">Revisions</a><div id="revisions" style="display:none"><br/>This is <b>first</b> revision</div>');
    reloadScript('documents.js');
    WebsiteOne.Documents.init();
  });

  it('prevents refreshing the page after link gets clicked', function() {
    var submitSpy = jasmine.createSpy('submitSpy')
    $(document).on('submit', submitSpy);

    $('#revisions-anchor').trigger('cklick');

    expect(submitSpy).not.toHaveBeenCalled();
  });

  it('shows revisions div after Revisions link is clicked', function(){
    //expect($('#revisions')).toHaveAttr('style', 'display:none');
    $('#revisions-anchor').trigger('click');
    expect($('#revisions')).toBeVisible();
  });

  it('hides revisions div after Revisions is clicked twice', function(){
    $('#revisions-anchor').trigger('click');
    $('#revisions-anchor').trigger('click');
    expect($('#revisions')).toBeHidden();
  });
});
