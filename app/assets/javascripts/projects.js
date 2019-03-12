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
    },
    ensure_issue_tracker_numbering: function() {
      
      var issueTrackers = $('#project_form').find('.nested-issue-tracker-fields');
      var issueTrackersSize = $(issueTrackers).size()
      
      if(issueTrackersSize > 1) {
        for (var i = 1; i< issueTrackersSize; i++) {
          $(issueTrackers[i]).find('.issue_tracker_field_label').html('Issue Tracker (' + (i + 1) + ')')
        }
      }
    }
  }
});

$(document).on('ready', function () {
  WebsiteOne.Projects.ensure_github_url_numbering()
  WebsiteOne.Projects.ensure_issue_tracker_numbering()

  $('#source_repositories').on('cocoon:after-insert', function (e, added_repo) {
    WebsiteOne.Projects.ensure_github_url_numbering()
  });
  $('#issue_trackers').on('cocoon:after-insert', function (e, added_issue_tracker) {
    WebsiteOne.Projects.ensure_issue_tracker_numbering()
  });

  var params = "&infinite=true"
  infiniteScroll(params);
});
