class Video < ActiveRecord::Base
  serialize :currently_in
  serialize :participants

  def started?
    true
  end

  def live?
    true
  end
end
