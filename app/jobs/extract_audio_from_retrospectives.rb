require 'youtube-dl.rb'
require 'restclient'
require 'nokogiri'

PAGE_URL = "https://www.agileventures.org/events/av-retrospective"
OPTIONS = {
  continue: true,
  ignore_errors: true,
  extract_audio: true,
  audio_format: 'mp3',
}

module ExtractAudioFromRetrospectivesJob
  extend self
  
  def run 
    page = Nokogiri::HTML(RestClient.get(PAGE_URL))
    latest_retrospective = page.css('.yt_link')[0]['id']
    
    YoutubeDL.download "#{latest_retrospective}", OPTIONS
  end
end