class VisitorsController < ApplicationController
  include ApplicationHelper

  def index
    # disable countdown clock by setting @next_event to nil
    @event = @next_event
    @next_event = nil

    render layout: false
  end
end
