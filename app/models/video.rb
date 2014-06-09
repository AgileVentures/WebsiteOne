class Video < ActiveRecord::Base
  serialize :currently_in
  serialize :participants

  def started?
    true if hangout_url
  end

  def live?
    true if status == 'In progress'
  end

  def youtube_url
    'http://youtube.test/' + youtube_id.to_s if youtube_id
  end

  def currently_ins
    self.currently_in.join(' ') if currently_in
  end

  def participantss
    self.participants.join(' ') if currently_in
  end
end
