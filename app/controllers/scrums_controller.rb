class ScrumsController < ApplicationController

  def index
    #@scrums = Scrum.all
    client = YouTubeIt::Client.new(:dev_key => Rails.application.secrets.youtube_api_key)
    query = client.videos_by(:query => "AtlanticScrum|AmericasScrum|EuroScrum Pair Hookup", 
                             :order_by => :published,
                             :max_results => 20)
    @scrums = query.videos.map { |video| video_data(video) }
  end

  private

  def video_data(video)
    {
        author: video.author.name,
        id: video.video_id.scan(/tag:youtube.com,\d+:video:(.+)/).last.first,
        published: video.published_at.to_date,
        title: video.title,
        content: video.title,
        url: video.media_content[0].url
    }
  end


end
