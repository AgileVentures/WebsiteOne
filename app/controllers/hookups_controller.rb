class HookupsController < ApplicationController
  def index
    @pending_hookups = Event.pending_hookups
    @active_pp_hangouts = Hangout.pp_hangouts.started.live
  end
end
