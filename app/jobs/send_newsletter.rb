module SendNewsletter

  def self.run
    job = Job.new
    job.execute
  end

  class Job

    def initialize
      @newsletter = Newsletter.unsent.take
    end

    def execute
      if @newsletter
        return nil if setup_potential_recipients.empty?
        last_user = process_recipients
        clean_up(last_user)
      else
        return nil
      end
      true
    end

    private

    def setup_potential_recipients
      users = User.mail_receiver.order('id ASC').where('id >?', @newsletter.last_user_id)
      @total_recipients = users.size
      @users = users.limit(Newsletter.chunk_size)
    end

    def select_receiver
      puts "selecting recipients"

    end

    # returnes last user processed
    #
    def process_recipients
      last_user = nil
      @users.each do |user|
        Mailer.send_newsletter(user, @newsletter).deliver
        last_user = user
      end
      last_user
    end

    def clean_up(last_user)
      if @total_recipients <= Newsletter.chunk_size
        @newsletter.update_attributes(  was_sent: true,
                                        last_user_id: last_user.id,
                                        sent_at: Time.now )
      else
        @newsletter.update_attribute(:last_user_id, last_user.id)
      end
    end
  end


end
