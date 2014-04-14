class ScrumsController < ApplicationController
  def index
    @scrums = Scrum.all
  end
end

