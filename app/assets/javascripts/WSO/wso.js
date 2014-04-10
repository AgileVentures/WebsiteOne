/*
 To deal with the headache of initializing JavaScripts with TurboLinks, I wrote this custom
 module definer to handle initialization code

 modules can be defined using the following snippet:

 window.WSO.define('<Module Name>', function() {
     return <Module Object>;
 });

 The module's init method will automatically be called on TurboLink's page:load or document ready event
 */

window.WSO = window.WSO || (function() {
  var modules = [];

  function define(name, factory) {
    window.WSO[name] = window.WSO[name] || (function() {
      modules.push(name);
      return factory();
    })();
  }

  function init() {
    for (var i = 0; i < modules.length; i++) {
      window.WSO[modules[i]].init();
    }
  }

  return {
    init: init,
    define: define,
    registered: false
  }
})();

$(function() {
  if (!window.WSO.registered) {
    $(document).ready(window.WSO.init);
    $(document).on('page:load', window.WSO.init);
    window.WSO.registered = true;
  }
});
