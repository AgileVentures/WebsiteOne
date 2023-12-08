# constant-redefinition

Allows you to define constants if not defined on an object (or module) and redefine constants without warning.

## Installation

`gem install constant-redefinition`

or in your `Gemfile`

```ruby
gem 'constant-redefinition'
```

## Usage

Define a constant if not defined:

```ruby
define_if_not_defined(:A, 1)
 => nil 
A
 => 1 
```

Define a constant and redefine it:

```ruby
define_if_not_defined(:B, 1)
 => nil 
redefine_without_warning(:B, 2)
 => 2 
B
 => 2 
```

Redefine a constant which should set the constant:    

```ruby
redefine_without_warning(:C, 3)
 => 3 
C
 => 3 
```

Define a constant within a module:

```ruby
Math.define_if_not_defined(:FOO, 2 * Math::PI)
 => nil 
Math::FOO
 => 6.283185307179586 
```

Define and redefine a constant within a module:

```ruby
Math.define_if_not_defined(:BAR, 3)
 => nil 
Math.redefine_without_warning(:BAR, 5)
 => 5 
Math::BAR
 => 5 
```

Redefine a constant within a module which should set the constant:

```
Math.redefine_without_warning(:AMAZING, 3)
 => 3 
Math::AMAZING
 => 3 
```

You can also define a constant using a block which will unset the constant after the block:

```ruby
class Freaks
  GOOBLE = 'gobble'
end
 => "gobble" 

Freaks.define_if_not_defined(:HELLO, 'world') do
    p Freaks::HELLO
end
"world"
 => "world" 

p Freaks::HELLO
NameError: uninitialized constant Freaks::HELLO
```

You can also redefine a constant using a block, which will reset the constant to its original value after the block:

```ruby
class Freaks
  GOOBLE = 'gobble'
end
 => "gobble" 
 
Freaks.redefine_without_warning(:GOOBLE, 'one of us') do
  p Freaks::GOOBLE
end

"one of us"
 => "gobble" 
```

All credit is due to this post: http://stackoverflow.com/questions/3375360/how-to-redefine-a-ruby-constant-without-warning

## Contributing to constant-redefinition
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2010-2012 David Czarnecki. See LICENSE.txt for further details.