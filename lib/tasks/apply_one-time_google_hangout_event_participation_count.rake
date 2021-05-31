# frozen_string_literal: true

desc 'Modifies the event_participation_count with the values from the specified file'

# This task is meant to be ran only once to update the users past google hangouts event_participation_count
task modify_event_participation: :environment do
  ModifyEventParticipation.run
end
