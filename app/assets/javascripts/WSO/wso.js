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
  var modules = [],
      newPageLoaded = false;

  function define(name, factory) {
    window.WSO[name] = window.WSO[name] || (function() {
      modules.push(name);
      var newModule = factory();

      if (!window.WSO._newPageLoaded) {
        newModule.init();
      }

      return newModule;
    })();

    return window.WSO[name];
  }

  function clear() {
    for (var i = 0; i < modules.length; i++) {
      delete window.WSO[modules[i]];
    }

    modules.length = 0;
  }

  function init() {
    for (var i = 0; i < modules.length; i++) {
      window.WSO[modules[i]].init();
    }

    window.WSO._newPageLoaded = false;
  }

  return {
    _init: init,
    define: define,
    _modules: modules,
    _registered: false,
    _newPageLoaded: newPageLoaded,
    _clear: clear
  }
})();

window.WSO._newPageLoaded = true;

$(function() {
  if (!window.WSO._registered) {
    $(document).ready(window.WSO._init);
    $(document).on('page:load', window.WSO._init);
    window.WSO._registered = true;
  }
});
