//= require mercury

jQuery(window).on('mercury:ready', function() {
  var mercuryiframe = $('#mercury_iframe'),
      editLink = mercuryiframe.contents().find('#edit_link'),
      newDocLink = mercuryiframe.contents().find('#new_document_link'),
      cancelLink = mercuryiframe.contents().find('#cancel_link'),
      saveLink = mercuryiframe.contents().find('#save_link');

  Mercury.saveUrl = editLink.data('save-url');
  editLink.hide();

  newDocLink.hide();

  cancelLink.show();

  saveLink.show();
  saveLink.on('click', function(event) {
    event.preventDefault();
    $('.mercury-button.mercury-save-button').click();
  });

  mercuryiframe.contents().find("#static_page_title .mercury-textarea").css("width", "125%");
});

jQuery(window).on('mercury:saved', function() {
    window.location.href = window.location.href.replace(/\/editor\//i, '/') + '/mercury_saved';
});

