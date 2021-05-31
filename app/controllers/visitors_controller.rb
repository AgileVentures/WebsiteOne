# frozen_string_literal: true

class VisitorsController < ApplicationController
  include ApplicationHelper

  def index
    # disable countdown clock by setting @next_event to nil
    @event = @next_event
    @next_event = nil

    render layout: false
  end

  def get_next_scrum
    if Features.get_next_scrum_homepage.enabled
      super
    else
      @next_event = nil
    end
  end
end
