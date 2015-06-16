class ScrumsController < ApplicationController
  def index
    @scrums = EventInstance.where(category: 'Scrum').limit(20)
  end
end
