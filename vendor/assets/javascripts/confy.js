/**
 * confy v0.1 - http://scriptpie.com
 *
 * Copyright - 2013 Mihai Buricea (http://www.scriptpie.com)
 * All rights reserved.
 *
 * You may not modify and/or redistribute this file
 * save cases where Extended License has been purchased
 *
 */

(function ($, window, document, undefined) {

    "use strict";

    // Utility
    if (typeof Object.create !== 'function') {
        Object.create = function (obj) {
            function F () {}
            F.prototype = obj;
            return new F();
        };
    }

    var pluginName = 'confy',
        pluginNamespace = 'cfy',
        eventNamespace = '.' + pluginNamespace,
        pluginObject = {
//@todo - sa nu se mai poata schimba nicio optiune pana nu se incarca complet plugin-ul
            /**
             * Init the plugin
             */
            init: function (options) {

                var t = this;

                t.stopPlugin = false;

                t._browserInfo();

                // extend options
                t.options = $.extend({}, $.confy.options, options);

                // init events
                t.initEvents();

                t._populate();

            },

            /**
             * Get info about client browser
             */
            _browserInfo: function () {

                var appVersion  = navigator.appVersion;

                if (appVersion.indexOf("MSIE 8.") !== -1) { // ie8
                    this.browser = 'ie8';
                } else if (appVersion.indexOf("MSIE 9.") !== -1) { // ie9
                    this.browser = 'ie9';
                } else if (appVersion.indexOf("MSIE 10.") !== -1) { // ie10
                    this.browser = 'ie10';
                } else if ( (/android/gi).test(appVersion) ) { // android
                    this.browser = 'android';
                } else if ( (/iphone|ipad|ipod/gi).test(appVersion) ) { // ios
                    this.browser = 'ios';
                } else {
                    this.browser = '';
                }
            },

            /**
             * Populate confy interface with options
             */
            _populate: function () {

                var t = this, data, option;

                t.options.items.each(function (index, item) {

                    item = $(item);

                    data = {
                        type: item.data('type'),
                        value: item.data('value'),
                        option: item.data('option')
                    };

                    switch (data.type) {
                        case 'radio':
                            option = t._getValueFromString(data.option);
                            if (data.value === option) {
                                item.addClass('cfy-active');
                            }
                            break;

                        case 'textfield':
                            option = t._getValueFromString(data.option);
                            item.val(option);
                            item.data('value', option);
                            break;

                        case 'checkbox':
                            option = t._getValueFromString(data.option);

                            if (option) {
                                item.addClass('cfy-on');
                                item.data('value', 'true');
                            } else {
                                item.removeClass('cfy-on');
                                item.data('value', 'false');
                            }
                            break;

                        case 'selectbox':
                            option = t._getValueFromString(data.option);
                            item.data('value', option);
                            item.find('option[data-value=' + option + ']').prop({selected: true});
                            break;

                    }

                });

                // create dependencies
                t.options.dependencies.call(t, t.options.settings);

            },

            _getValueFromString: function (option) {

                var t = this,
                    split = option.split('.'),
                    i,
                    temp = t.options.settings[split[0]];

                for (i = 1; i < split.length; i++) {
                    temp = temp[split[i]];
                }

                return temp;

            },

            _setValueFromString: function (option, value) {

                var t = this,
                    split = option.split('.'),
                    len = split.length,
                    i,
                    temp;

                if (len === 1) {
                    t.options.settings[split[0]] = value;
                } else {

                    temp = t.options.settings[split[0]];

                    for (i = 1; i < len - 1; i++) {
                        temp = temp[split[i]];
                    }

                    temp[split[len-1]] = value;
                }

            },

            /**
             * Change options to new settings
             */
            _change: function (item) {

                var t = this,
                    option = {},
                    data = {
                        type: item.data('type'),
                        value: item.data('value'),
                        option: item.data('option')
                    };

                if (item.hasClass('cfy-active')) {
                    return;
                }

                // loading start
                t.options.loadingStart.call(t);

                t._reset();

                switch (data.type) {
                    case 'radio':
                        t._setValueFromString(data.option, data.value);
                        break;

                    case 'textfield':
                        data.value = parseInt(data.value, 10);

                        data.value = ( (data.value % 1) === 0 )? data.value : 0;

                        item.data('value', data.value);

                        t._setValueFromString(data.option, data.value);
                        break;

                    case 'checkbox':
                        data.value = (data.value == "true" )? false : true;
                        t._setValueFromString(data.option, data.value);
                        break;

                    case 'selectbox':
                        t._setValueFromString(data.option, data.value);
                        break;

                }

                setTimeout(function () {

                    // call callback function
                    t.options.callback.call(t, t.options.settings);

                    t._populate();

                    t.options.loadingEnd.call(t, t.options.settings);

                }, 200);

            },

            /**
             * Reset all items
             */
            _reset: function () {

                var t = this, option;

                t.options.items.each(function (index, item) {

                    item = $(item);

                    var data = {
                        type: item.data('type'),
                        value: item.data('value'),
                        option: item.data('option')
                    };

                    switch (data.type) {
                        case 'radio':
                            option = t._getValueFromString(data.option);
                            if (data.value === option) {
                                item.removeClass('cfy-active');
                            }
                            break;

                        case 'textfield':
                            //item.val('');
                            item.data('value', '');
                            break;

                        case 'checkbox':
                            option = t._getValueFromString(data.option);
                            if (option) {
                                item.removeClass('cfy-on');
                                item.data('value', '');
                            }
                            break;

                        case 'selectbox':
                            //item.val('');
                            item.data('value', '');
                            break;

                    }

                });

            },


            showConfy: function (toggleButton, byUser) {

                toggleButton.removeClass('cfy-toggle-close');

                this.options.wrap.css({left: 0});

                this.options.show.call(this);

                if (byUser) {
                    localStorage.confyPlugin = JSON.stringify({"closedByUser": "false"});
                }
            },


            hideConfy: function (toggleButton, byUser) {

                toggleButton.addClass('cfy-toggle-close');

                this.options.wrap.css({left: -261});

                this.options.hide.call(this);

                if (byUser) {
                    localStorage.confyPlugin = JSON.stringify({"closedByUser": "true"});
                }

            },


            toggleConfy: function (toggleButton, byUser) {

                if (toggleButton.hasClass('cfy-toggle-close')) {
                    this.showConfy(toggleButton, byUser);
                } else {
                    this.hideConfy(toggleButton, byUser);
                }

            },


            initEvents: function () {

                var t = this;

                t.options.items.filter('[data-type="radio"], [data-type="checkbox"]').on('click' + eventNamespace, function (e) {

                    // if stop plugin is true go out from here
                    if (t.stopPlugin) return;

                    t._change($(this));

                    e.preventDefault();

                });

                t.options.items.filter('[data-type="textfield"]').on('keypress' + eventNamespace, function (e) {

                    // if stop plugin is true go out from here
                    if (t.stopPlugin) return;

                    var item = $(this),
                        code = (e.keyCode ? e.keyCode : e.which);

                    if (code === 13) {

                        item.data('value', item.val());

                        t._change(item);
                    }

                });

                t.options.items.filter('[data-type="selectbox"]').on('_change' + eventNamespace, function (e) {

                    // if stop plugin is true go out from here
                    if (t.stopPlugin) return;

                    var item = $(this),
                        value = item.find("option:selected").data('value');

                    item.data('value', value);

                    t._change(item);

                });

                // on click -> trigger the plugin
                $(".cfy-toggle").on('click', function () {

                    t.toggleConfy($(this), true);

                });

                // on resize event
                $(window).on('resize', function (e) {
                    t.resize();
                });

                if (t.options.startOpen) {
                    t.showConfy($('.cfy-toggle'));
                }

                // resize function
                t.resize();

            },

            resize: function () {

                var t = this, width = $(window).width(), opt;

                if (localStorage.confyPlugin) {

                    opt = JSON.parse(localStorage.confyPlugin);

                    if (opt.closedByUser === "false") {
                        t.showConfy($('.cfy-toggle'));
                    } else {
                        t.hideConfy($('.cfy-toggle'));
                    }

                } else if (width < 1024) {

                    setTimeout(function () {

                        t.hideConfy($('.cfy-toggle'));

                    }, 1000);

                }
            }

        };

    $.confy = Object.create(pluginObject);

    // Plugin default parameters
    $.confy.options = {

        wrap: $(".cfy-wrap"),

        items: $('.cfy-item'),

        startOpen: true,

        // trigger callback after each change to confy
        callback: function (options) {},

        loadingStart: function () {
            $('.cfy-wrap').addClass('cfy-wrap-loading');
        },

        loadingEnd: function () {
            $('.cfy-wrap').removeClass('cfy-wrap-loading');
        },

        dependencies: function (options) {},

        hide: function () {},

        show: function () {},

        // get settings from plugin
        settings: null
    };

})(jQuery, window, document);
