describe('Users', function() {
  beforeEach(function (){
    setFixtures(sandbox({ id: 'user-filter' }));
    appendSetFixtures('<ul class="media-list"><li id="bob">Bob Jones</li><li id="alice">Alice Drew</li></ul>');

    $('#user-filter').on('keyup', function(e){
      e.preventDefault();

      var searchString = $(this).val().trim().toLowerCase();
      var users= $('.media-list li');

      filtered = $(users).filter(function() {
        return $(this).text().toLowerCase().match(searchString);
      }).show();
      $(users).not(filtered).hide();
    });
  });

  it('prevents submiting the filter form on Enter key', function() {
    var submitSpy = jasmine.createSpy('submitSpy')
    $(document).on('submit', submitSpy);

    $('#user-filter').trigger('keydown');

    expect(submitSpy).not.toHaveBeenCalled();
  });

// check that found is shown (small and capital letters), not found is hidden, all shown if searchString is empty

  it('shows users if contains serach string', function() {
    // window.WebsiteOne._clear();
    // window.WebsiteOne._init();
    $('#user-filter').val('bob');
    $('#user-filter').trigger('keyup');
    expect($('#bob')).toBeVisible();
    expect($('#alice')).toBeHidden();
  });



});
