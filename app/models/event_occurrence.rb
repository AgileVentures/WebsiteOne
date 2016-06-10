EventOccurrence = Struct.new(:event, :time)
=begin
class EventOccurrence
  attr_reader :event, :time
  def initialize(event, time)
    @event = event
    @time  = time
  end
end
=end