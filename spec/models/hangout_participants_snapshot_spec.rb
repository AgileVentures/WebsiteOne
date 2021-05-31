# frozen_string_literal: true

describe HangoutParticipantsSnapshot do
  it { should belong_to(:event_instance) }
end
