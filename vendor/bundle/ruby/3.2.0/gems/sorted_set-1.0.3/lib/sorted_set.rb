# :markup: markdown

require 'set'

return if defined?(JRUBY_VERSION)

require 'rbtree'

Object.instance_exec do
  # Undefine SortedSet for two reasons.
  #
  # 1. We should wipe out an existing implementation if Ruby 2.x loads
  #    this library after loading the standard set library which
  #    defines SortedSet.
  #
  # 2. Ruby >=3.0 (set >=1.0.0) sets autoload on SortedSet, and we
  #    shouldn't let the following reference to SortedSet fire it
  #    because it would end up requiring this library, leading to
  #    circular require.
  #
  remove_const :SortedSet if const_defined?(:SortedSet)
end

##
# SortedSet implements a Set whose elements are sorted in ascending
# order (according to the return values of their `<=>` methods) when
# iterating over them.
#
# Every element in SortedSet must be *mutually comparable* to every
# other: comparison with `<=>` must not return nil for any pair of
# elements.  Otherwise ArgumentError will be raised.
#
# ## Example
#
# ```ruby
# require "sorted_set"
#
# set = SortedSet.new([2, 1, 5, 6, 4, 5, 3, 3, 3])
# ary = []
#
# set.each do |obj|
#   ary << obj
# end
#
# p ary # => [1, 2, 3, 4, 5, 6]
#
# set2 = SortedSet.new([1, 2, "3"])
# set2.each { |obj| } # => raises ArgumentError: comparison of Fixnum with String failed
# ```

class SortedSet < Set
  # Creates a SortedSet.  See Set.new for details.
  def initialize(*args)
    @hash = RBTree.new
    super
  end
end
