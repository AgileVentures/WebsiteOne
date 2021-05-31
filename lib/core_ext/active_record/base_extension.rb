# frozen_string_literal: true

module ActiveRecord
  class Base
    def presenter
      @_presenter_ ||= "#{self.class}Presenter".constantize.new(self)
    end
  end
end
