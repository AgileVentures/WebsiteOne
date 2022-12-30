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
      ensure_numbering(sourceRepositories, 'repo_field_label', 'GitHub url')
    },
    ensure_issue_tracker_numbering: function () {

      var issueTrackers = $('#project_form').find('.nested-issue-tracker-fields');
      ensure_numbering(issueTrackers, 'issue_tracker_field_label', 'Issue Tracker')
    }
  }
});

function ensure_numbering(element, field_label_class, label_text) {

  if (element.size() > 1) {
    for (var i = 1; i < element.size(); i++) {
      $(element[i]).find('.' + field_label_class).html(label_text + ' (' + (i + 1) + ')')
    }
  }
}

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

var ProjectListFilter = {
  filter_inactive: function() {
    if ($(this).is(':checked')) {
      $('a.inactive').css({ display: "none" });
      $('i.inacive').css({ display: "none" });
      $('li.inacive').css({ display: "none" });
    } else {
      $('a').css({ display: "" });
      $('i.fa').css({ display: "" });
      $('div.a').css({ display: "" });
    }
  },
  setup: function() {
    var labelAndCheckbox =
    $('<form class="checkbox-inline"><input type="checkbox" id="activefilter" checked=true>' +
      '<label for="activeFilter">Show Active Only</label></form>');
    labelAndCheckbox.insertAfter('#project-filters');
    $('#activefilter').on("click", ProjectListFilter.filter_inactive);
  }
}
$(ProjectListFilter.setup);
