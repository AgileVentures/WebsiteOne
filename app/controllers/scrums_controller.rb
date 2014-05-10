class ScrumsController < ApplicationController

  def index
    #@scrums = Scrum.all
    client = YouTubeIt::Client.new(:dev_key => "AIzaSyAh0CZ-jWpREV-3WtQ-4thTW0T-qU6_zrc")
    query = client.videos_by(:query => "agile ventures scrums")
    @scrums = query.videos.map(&:video_id).map{ |str| str.scan(/tag:youtube.com,\d+:video:(.+)/).last.first}
  end

  private

  def video_data(video)

    # TODO: Work in Progress
    {
        author: video.author.name,
        id: video.video_id.scan(/tag:youtube.com,\d+:video:(.+)/).last.first,
        published: video.published_at.to_date,
        title: video.title,
        content: hash['content']['$t'],
        url: video.url
    }
  end
end








