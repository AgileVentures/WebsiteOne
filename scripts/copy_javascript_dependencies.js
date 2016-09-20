#!/usr/bin/env node
var copyfiles = require('copyfiles');

copyfiles(['node_modules/moment/min/moment.min.js', 'vendor/assets/javascripts'], true, function(err,files){

});


copyfiles(['node_modules/moment-timezone/builds/moment-timezone-with-data-2010-2020.js', 'vendor/assets/javascripts'], true, function(err,files){

});