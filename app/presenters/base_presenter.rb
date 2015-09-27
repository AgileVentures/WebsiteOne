require 'action_view'

class BasePresenter
  include ActionView::Helpers::UrlHelper,
    ActionView::Helpers::DateHelper,
    ActionView::Helpers::AssetTagHelper

  delegate :url_helpers, to: 'Rails.application.routes'

  attr_reader :object

  def initialize(object)
    @object = object
  end

  def self.presents(name)
    define_method(name) do
      @object
    end
  end

  def object_age_in_words
    distance_of_time_in_words(object.created_at.to_date, Date.current)
  end

  def method_missing(*arguments, &block)
    object.send(*arguments, &block)
  end
end
