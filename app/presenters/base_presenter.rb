require 'action_view'

class BasePresenter

  include ActionView::Helpers::UrlHelper, ActionView::Helpers::DateHelper

  attr_reader :object

  def initialize(object)
    @object = object
  end

  def object_age_in_words
    distance_of_time_in_words(object.created_at.to_date, Date.current)
  end

  def method_missing(method, *arguments, &block)
    object.send(method, *arguments, &block)
  end
end
