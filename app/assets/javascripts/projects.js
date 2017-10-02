WebsiteOne.define('Projects', function () {
  return {
    init: function () {

      var hash = window.location.hash;

      if (hash) {
        $('a[data-hash="' + hash.replace('#', '') + '"]').tab('show');
      }

      $('.nav-tabs a').click(function (e) {
        setHash($(this).data('hash'));
        $(this).tab('show');
      });

      var setHash = function (newHash) {
        window.location.hash = newHash;
      };
    },
    ensure_github_url_numbering: function () {
      var sourceRepositories = $('#project_form').find('.nested-fields');
      var sourceRepositoriesSize = $(sourceRepositories).size();

      if (sourceRepositoriesSize > 1) {
        for (var i = 1; i < sourceRepositoriesSize; i++) {
          $(sourceRepositories[i]).find('.repo_field_label').html('GitHub url (' + (i + 1) + ')')
        }
      }
    }
  }
});

$(document).on('ready', function () {
  WebsiteOne.Projects.ensure_github_url_numbering()
  
  $('#source_repositories').on('cocoon:after-insert', function (e, added_repo) {
    WebsiteOne.Projects.ensure_github_url_numbering()
  });
})