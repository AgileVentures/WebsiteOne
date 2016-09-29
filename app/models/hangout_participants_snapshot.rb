class HangoutParticipantsSnapshot < ActiveRecord::Base
  belongs_to :event_instance
  serialize :participants
end