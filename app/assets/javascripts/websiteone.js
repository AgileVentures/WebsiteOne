// To deal with the headache of initializing JavaScripts with TurboLinks, I
// wrote this custom module definer to handle initialization code
//
// modules can be defined using the following snippet:
//
// window.WebsiteOne.define('<Module Name>', function() {
//     return <Module Object>;
// });
//
// The module's init method will automatically be called on TurboLink's
// page:load or document ready event
window.WebsiteOne =
  window.WebsiteOne ||
  (function() {
    var modules = [],
      newPageLoaded = false,
      runOnceCallbacks = {},
      moduleFactories = {};

    //hook for spec helper to hook into to get the original factory
    //and restore it
    function restoreModule(name){
      define(name, moduleFactories[name]);
    }

    function define(name, factory) {
      window.WebsiteOne[name] =
        window.WebsiteOne[name] ||
        (function() {
          modules.push(name);
          var newModule = factory();
          //bit of a hack to support jasmine unit testing!
          moduleFactories[name] = factory;

          if (!window.WebsiteOne._newPageLoaded) {
            newModule.init();
          }

          return newModule;
        })();

      return window.WebsiteOne[name];
    }

    function runOnce(name, callback) {
      runOnceCallbacks[name] = runOnceCallbacks[name] || {
        callback: callback,
        executed: false
      };
    }

    function clear() {
      for (var i = 0; i < modules.length; i++) {
        delete window.WebsiteOne[modules[i]];
      }
      modules.length = 0;
    }

    function init() {
      for (var i = 0; i < modules.length; i++) {
        window.WebsiteOne[modules[i]].init();
      }

      for (var name in runOnceCallbacks) {
        if (!runOnceCallbacks[name].executed) {
          runOnceCallbacks[name].callback();
          runOnceCallbacks[name].executed = true;
        }
      }

      window.WebsiteOne._newPageLoaded = false;
    }

    return {
      _init: init,
      define: define,
      runOnce: runOnce,
      _modules: modules,
      _registered: false,
      _newPageLoaded: newPageLoaded,
      _clear: clear,
      _restoreModule: restoreModule
    };
  })();

window.WebsiteOne._newPageLoaded = true;
