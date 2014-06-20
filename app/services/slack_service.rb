class SlackService
  include HTTParty
  base_uri 'https://agile-bot.herokuapp.com'

  def self.post_hangout_notification(hangout)
    post '/hubot/hangouts-notify', {
      body: {
        title: hangout.event.name,
        link: hangout.hangout_url,
        type: hangout.event.category
      }
    }
  end
end
