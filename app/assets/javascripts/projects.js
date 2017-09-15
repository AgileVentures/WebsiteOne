WebsiteOne.define('Projects', function() {
  return {
    init: function() {

      var hash = window.location.hash;

      if (hash) { 
        $('a[data-hash="'+hash.replace('#','')+'"]').tab('show');
      } 

      $('.nav-tabs a').click(function (e) {
        setHash($(this).data('hash'));
        $(this).tab('show');
      });

      var setHash = function(newHash) {
        window.location.hash = newHash;
      };
    },
    setupAddRepoButton: function () {
      $('#add_repo_field_button').click(function(event){
        event.preventDefault()

        var new_html = '<div class="form-group"> \
            <label class="control-label" for="project_github_url">GitHub link</label>\
            <input class="form-control" \
                   placeholder="https://github.com/projectname" name="project[github_url]" id="project_github_url">\
              </div>'
        $(new_html).insertAfter('#project_github_url')
        return false
      })
    }
  }
});


$(document).on('ready page:load', WebsiteOne.Projects.setupAddRepoButton)