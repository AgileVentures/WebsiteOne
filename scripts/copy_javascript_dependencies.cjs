#!/usr/bin/env node
var copyfiles = require('copyfiles');

copyfiles([
    'node_modules/nprogress/nprogress.js',
    'node_modules/corejs-typeahead/dist/typeahead.jquery.js',
    'node_modules/moment/min/moment.min.js',
    'node_modules/moment-timezone/builds/moment-timezone-with-data-2012-2022.js',
    'vendor/assets/javascripts'],
    true,
    function (err, files) { });