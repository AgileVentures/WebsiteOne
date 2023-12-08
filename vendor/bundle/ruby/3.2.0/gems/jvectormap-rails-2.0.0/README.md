jvectormap-rails
================

[jVectorMap](http://jvectormap.com/) for the Rails asset pipeline

### Installation

Add it to your `Gemfile`:
```
gem 'jvectormap-rails', '~> 1.0.0'
```

### Usage

You can add jvectormap-rails to your `application.js` file using a require statement like this:

```
//= require jvectormap
```

Don't forget to add the CSS to your `application.css` file too:

```
*= require 'jvectormap'
```

To add support for whatever maps you want to use, include them in `application.js`:

```
//= require jvectormap/maps/us_merc_en
```

The basic pattern is `{country}-{region}_{city}_{projection}`.  For example, the map `us-il-chicago_mill` has a country of `us` (United States), region of `il` (Illinois), city of `chicago`, and a projection of `mill` (Miller).  Other common projections include Mercator (`merc`), and Albers equal area (`aea`).

### Asset Precompilation

jvectormap-rails supports precompiling individual maps.  Add an initializer to your app, eg. `config/initializers/jvectormap.rb`:

```ruby
JVectorMap::Rails.precompile_maps << 'us_merc'
```

### Rake Tasks

Get a list of all available maps by running this from within your Rails app's root:

```
bundle exec rake jvectormap:maps
```

### License

Licensed under the MIT license.

### Authors

1.  This gem: Cameron Dutro [@camertron](http://twitter.com/camertron)
2.  jVectorMap: Kirill Lebedev, it's [on github](https://github.com/bjornd/jvectormap)
