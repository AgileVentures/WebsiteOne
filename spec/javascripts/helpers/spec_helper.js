beforeEach(function() {
  // clears the WSO module's state
  WebsiteOne._clear();
  WebsiteOne._newPageLoaded = true;
});

function reloadModule(name) {
  WebsiteOne._restoreModule(name);
}
