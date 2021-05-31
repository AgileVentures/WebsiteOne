# frozen_string_literal: true

class ScrumsController < ApplicationController
  def index
    @scrums = EventInstance.where(category: 'Scrum').last(20).sort { |a, b| b.created_at <=> a.created_at }
  end
end
