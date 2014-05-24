module ActiveRecord
  class Base
    def presenter
      "#{self.class}Presenter".constantize.new(self)
    end
  end
end
