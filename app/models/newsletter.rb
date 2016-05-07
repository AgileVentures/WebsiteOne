class Newsletter < ActiveRecord::Base
  validates       :subject, :title, :body, presence: true
  after_save      :send_mailings, if: :instantly_sendable?
  before_create   :init_last_user_id
  scope           :unsent, -> { where(do_send: true, was_sent: false) }
  scope           :in_process, -> {
                    where('do_send = ? AND was_sent = ? AND last_user_id > ?', true, false, 0)
                  }

  # sent via sendGrid - there is a limit 200 mailings/day
  # so we can not send it at once but have to split in chunks
  # to be send out by heroku scheduler
  #
  SEND_AS    = Settings.newsletter.send_as
  CHUNK_SIZE = Settings.newsletter.chunk_size


  private

  def send_mailings
    _last_user = nil
    User.mail_receiver.order('id ASC').find_in_batches(batch_size: 100).each do |group|
      group.each do |user|
        Mailer.send_newsletter(user, self).deliver_now
        _last_user = user
      end
    end
    update_attributes(was_sent: true, sent_at: Time.now, last_user_id: _last_user.id)
  end

  def instantly_sendable?
    do_send == true && was_sent == false && SEND_AS == :instant
  end

  def init_last_user_id
    self.last_user_id = 0
  end
end
