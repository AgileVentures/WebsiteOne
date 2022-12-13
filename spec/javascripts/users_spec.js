describe('Users', function() {
  beforeEach(function (){
    setFixtures(sandbox({ id: 'user-filter' }));
    appendSetFixtures('<ul class="media-list"><li id="bob">Bob Jones</li><li id="alice">Alice Drew</li></ul>');

  reloadModule('Users');
  WebsiteOne.Users.init();
  });

  it('prevents submiting the filter form on Enter key', function() {
    var submitSpy = jasmine.createSpy('submitSpy')
    $(document).on('submit', submitSpy);

    $('#user-filter').trigger('keydown');

    expect(submitSpy).not.toHaveBeenCalled();
  });

  it('shows users if contains serach string with small letters', function() {
    $('#user-filter').val('bob');
    $('#user-filter').trigger('keyup');
    expect($('#bob')).toBeVisible();
    expect($('#alice')).toBeHidden();
  });

  it('shows users if it contains search string with capital letters', function() {
    $('#user-filter').val('Bob');
    $('#user-filter').trigger('keyup');
    expect($('#bob')).toBeVisible();
    expect($('#alice')).toBeHidden();
  });

  it('shows users if it contains symbols that need to be trimmed', function() {
    $('#user-filter').val('   Bob Jones   \t \n');
    $('#user-filter').trigger('keyup');
    expect($('#bob')).toBeVisible();
    expect($('#alice')).toBeHidden();
  });

  it('shows all the results when searchString is initially empty', function() {
    $('#user-filter').val('');
    $('#user-filter').trigger('keyup');
    expect($('#bob')).toBeVisible();
    expect($('#alice')).toBeVisible();
  });

});
