class ScrumsController < ApplicationController
  def index
    @scrums = EventInstance.where(category: 'Scrum').last(20)
  end
end
