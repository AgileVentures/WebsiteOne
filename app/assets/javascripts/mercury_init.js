//= require mercury

jQuery(window).on('mercury:ready', function() {
  var mercuryiframe = $('#mercury_iframe').contents();
  editLink = mercuryiframe.find('#edit_link'),
  newDocLink = mercuryiframe.find('#new_document_link'),
  cancelLink = mercuryiframe.find('#cancel_link'),
  saveLink = mercuryiframe.find('#save_link');

  Mercury.saveUrl = editLink.data('save-url');

  editLink.hide();
  newDocLink.hide();

  cancelLink.show();
  saveLink.show();

  saveLink.on('click', function(event) {
    event.preventDefault();
    $('.mercury-button.mercury-save-button').click();
  });

  mercuryiframe.find("#static_page_title .mercury-textarea").css("width", "125%");
  Mercury.addFormatBtn();

});

jQuery(window).on('mercury:saved', function() {
  window.location.href = window.location.href.replace(/\/editor\//i, '/') + '/mercury_saved';
});

  Mercury.addFormatBtn = function () {

    var mercuryiframe = $('#mercury_iframe').contents();
    var contentFormatBtn = $('.mercury-button.mercury-contentFormat-button');

    var toggleFormat = function (init) {

      var caption, title,
          content, curFormat,
          body, newBody;

      body = mercuryiframe.find('#document_body');
      curFormat = body.attr('data-mercury');

      if(init == 'init') {
        curFormat = (curFormat == 'markdown' ? 'full':'markdown');
      }

      if(curFormat == 'markdown') {
        caption = 'HTML';
        title = 'Switch to Markdown';
        curFormat = 'full';
        content = body.find('textarea').val();
      } else {
        caption = 'Markdown';
        title = 'Switch to HTML';
        curFormat = 'markdown';
        content = body.text();
      }

      contentFormatBtn.find('em').text(caption).attr('title', title);

      if(init != 'init') {

        newBody = $('<div id="document_body" data-mercury=' + curFormat + ' data-type="editable"></div>');

        newBody.text(content).insertAfter(body);
        body.remove();

        Mercury.trigger('reinitialize');
        Mercury.trigger('unfocus:regions');
        newBody.focus().find('textarea').focus();
      }
    };

    contentFormatBtn.find('em').css('background-image', 'url(/assets/mercury/toolbar/primary/action.png)');

    toggleFormat('init');
    contentFormatBtn.click(toggleFormat);
  };
