class ScrumsController < ApplicationController
  def index
    @scrums = EventInstance.where(category: 'Scrum').last(20).order(:created_at)
  end
end
