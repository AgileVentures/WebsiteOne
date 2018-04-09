class ModifyEventParticipation

  def self.run
    CSV.foreach("lib/tasks/event_participation/test.csv") do |id, count|
      user = User.find id
      user.event_participation_count = count
      user.save
    end
  end
end
