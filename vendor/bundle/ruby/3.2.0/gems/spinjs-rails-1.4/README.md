# Spin.js - spinner with no CSS, Images

Provides an easy-to-use Rails 3.1 asset for [Spin.js](http://fgnass.github.com/spin.js/)

# Install

Add it to your Rails application's `Gemfile`:

```ruby
gem 'spinjs-rails'
```

Then `bundle install`.


# Usage

Require `spin`:


```javascript
// application.js

//= require spin
```

or as [jQuery plugin](https://gist.github.com/1290439/):

```javascript
// application.js

//= require jquery.spin

// Then you can:

$(".abc").spin(); // Shows the default spinner
$(".abc").spin(false); // Hide the spinner

// Show customised spinner:
$(".abc").spin({
  lines: 12, // The number of lines to draw
  length: 7, // The length of each line
  width: 9, // The line thickness
  radius: 30, // The radius of the inner circle
  color: '#000', // #rgb or #rrggbb
  speed: 1, // Rounds per second
  trail: 60, // Afterglow percentage
  shadow: false // Whether to render a shadow
});

// Use customisation shortcuts:
$("#el").spin("small"); // Produces a 'small' Spinner using the text color of #el.
$("#el").spin("large", "white"); // Produces a 'large' Spinner in white (or any valid CSS color).
```

See the full usage details on the [spin.js](http://fgnass.github.com/spin.js/) site.


# License

[MIT](http://www.opensource.org/licenses/mit-license.php) by [@dnagir](https://twitter.com/dnagir).


# Thanks

Thanks to [all contributors](https://github.com/dnagir/spinjs-rails/graphs/contributors) and the author of the spin.js
