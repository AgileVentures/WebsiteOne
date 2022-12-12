beforeEach(function() {
  // clears the WSO module's state
  WebsiteOne._clear();
  WebsiteOne._newPageLoaded = true;
});

function reloadScript(name) {
  WebsiteOne._restoreModule(name);
}
