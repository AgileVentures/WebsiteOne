# frozen_string_literal: true

def nested_hash_value(obj, key)
  if obj.respond_to?(:key?) && obj.key?(key)
    obj[key]
  elsif obj.respond_to?(:each)
    r = nil
    obj.detect { |*a| r = nested_hash_value(a.last, key) }
    r
  end
end
