# frozen_string_literal: true

class HangoutParticipantsSnapshot < ApplicationRecord
  belongs_to :event_instance
end
