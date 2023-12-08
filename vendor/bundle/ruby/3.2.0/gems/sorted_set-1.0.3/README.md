# SortedSet

SortedSet implements a Set whose elements are sorted in ascending
order (according to the return values of their `<=>` methods) when
iterating over them.

Every element in SortedSet must be *mutually comparable* to every
other: comparison with `<=>` must not return nil for any pair of
elements.  Otherwise ArgumentError will be raised.

Currently this library does nothing for JRuby, as it has its own
version of Set and SortedSet.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sorted_set'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install sorted_set

## Usage

```ruby
require "sorted_set"

set = SortedSet.new([2, 1, 5, 6, 4, 5, 3, 3, 3])
ary = []

set.each do |obj|
  ary << obj
end

p ary # => [1, 2, 3, 4, 5, 6]

set2 = SortedSet.new([1, 2, "3"])
set2.each { |obj| } # => raises ArgumentError: comparison of Fixnum with String failed
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/knu/sorted_set.

## License

The gem is available as open source under either the terms of the [2-Clause BSD License](https://opensource.org/licenses/BSD-2-Clause).
