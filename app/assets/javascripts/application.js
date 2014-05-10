// This is a manifest file that will be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require jquery.turbolinks
//= require bootstrap
//= require nprogressbar
//= require bootstrap-datepicker
//= require bootstrap-timepicker
//= require typeahead
//= require bootstrap-tokenfield.min
//= require bootstrap-tags
//= require bootstrap/modal
//= require_self
//= require_directory ./websiteone-app

// Bryan: removed require_tree . because mercury causes problems if loaded on every page

// To deal with the headache of initializing JavaScripts with TurboLinks, I wrote this custom
// module definer to handle initialization code
//
// modules can be defined using the following snippet:
//
// window.WSO.define('<Module Name>', function() {
//     return <Module Object>;
// });
//
// The module's init method will automatically be called on TurboLink's page:load or document ready event

window.WSO = window.WSO || (function() {
  var modules = [],
      newPageLoaded = false,
      runOnceCallbacks = {};

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

  function runOnce(name, callback) {
    runOnceCallbacks[name] = runOnceCallbacks[name] || {
      callback: callback,
      executed: false
    }
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

    for (var name in runOnceCallbacks) {
      if (!runOnceCallbacks[name].executed) {
        runOnceCallbacks[name].callback();
        runOnceCallbacks[name].executed = true;
      }
    }

    window.WSO._newPageLoaded = false;
  }

  return {
    _init: init,
    define: define,
    runOnce: runOnce,
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
