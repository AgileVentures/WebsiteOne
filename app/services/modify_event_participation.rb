# frozen_string_literal: true

class ModifyEventParticipation
  def self.run
    CSV.foreach('lib/tasks/event_participation/event_participation_karma.csv') do |id, count|
      user = User.find id
      user.event_participation_count = count
      user.save
    end
  end
end
