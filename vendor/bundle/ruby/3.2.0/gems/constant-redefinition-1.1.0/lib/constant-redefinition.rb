class Object
  def define_if_not_defined(const, value)
    mod = self.is_a?(Module) ? self : self.class
    mod.const_set(const, value) unless mod.const_defined?(const)
    if block_given?
      yield      
      mod.send(:remove_const, const) if mod.const_defined?(const)
    end
  end

  def redefine_without_warning(const, value)
    mod = self.is_a?(Module) ? self : self.class
    if block_given?
      original_value = mod.const_get(const) if mod.const_defined?(const)
      constant_was_set = mod.const_defined?(const)
      mod.send(:remove_const, const) if mod.const_defined?(const)
      mod.const_set(const, value)
      yield
      mod.send(:remove_const, const) if mod.const_defined?(const)
      mod.const_set(const, original_value) if constant_was_set
    else
      mod.send(:remove_const, const) if mod.const_defined?(const)
      mod.const_set(const, value)
    end
  end
end
