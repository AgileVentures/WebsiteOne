require 'pp'

module AgileVentures
  class BulkMailer
  
    attr_reader :num_sent
    attr_reader :used_addresses

    # to send mail on rails-console:
    # apply copy'n'paste text to var in rails-console:
    # <tt>
    # 2.0.0-p353 :032 > content = <<EOF
    # 2.0.0-p353 :033"> there ought to be
    # 2.0.0-p353 :034"> multiline text
    # 2.0.0-p353 :035"> EOF
    # </tt>
    #
    # <b>then call with:</b>
    #
    # <tt>bulk = AgileVentures::BulkMailer.new(heading: 'my concern', 
    #                               subject: 'special subject',
    #                               content: content)</tt>
    # <tt>bulk.run</tt>
    # every user with enabled mailing in settings will receive this mailing.


    # opts[:content]::  the content or body of the mailing
    # opts[:heading]::  a specific headline for the mailing
    # opts[:batch_size]:: the batch-size in which users are pulled off db
    # opts[:subject]::    the subject header of the mailing
    #
    def initialize(opts)
      @heading = opts.fetch(:heading)
      @content = opts.fetch(:content)
      @batch_size = opts[:batch_size] || 50
      @subject = opts[:subject] || @heading
    end

    def run
      @num_sent = 0
      @used_addresses = []
      puts "about to send: #{@heading}\n#{pp(@content)}"
      opted_in_user_in_batches   
      @num_sent
    end

    # show some advice how to initiate
    # BulkMailer
    #
    def self.help
      help = "BulkMailer.new(heading: 'my_heading', 
                            subject: 'my subject', 
                            content: 'multiline text')\n
              opts[:content]::  the content or body of the mailing\n
              opts[:heading]::  a specific headline for the mailing\n
              opts[:batch_size]:: the batch-size in which users are pulled off db\n
              opts[:subject]::    the subject header of the mailing"    
      puts help
    end

    private

    def opted_in_user_in_batches
      User.where('receive_mailings = ?', true)
      .find_in_batches(batch_size: @batch_size) do |group|
        group.each do |user|
          ConsoleMailer.newsletter(user, {  heading: @heading, 
                                            content: @content,
                                            subject: @subject
                                         }).deliver
          @num_sent += 1
          @used_addresses.push user.email
          puts "#{user.email} - done;"
        end 
        waiting_seconds
      end
    end

    # to prevent beeing blacklisted/blocked we should wait
    # a couple seconds 
    #
    def waiting_seconds
      unless Rails.env == 'test'
        puts "wating 10 seconds before continuing..."
        (1..10).to_a.reverse.each do |sec|
          sleep(1)
          print ". "
        end
        puts "\ncontinuing"
      end
    end

  end
end
