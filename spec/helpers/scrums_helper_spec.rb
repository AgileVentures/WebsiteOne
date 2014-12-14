require 'spec_helper'

describe ScrumsHelper do

  describe '#scrum_embed_link' do
    it 'responds to youtube video' do
     
    	video = mock_model("Video", id: "3kc3zy2nb-U")

			visit 'scrums'

    	page.html.should include("http://www.youtube.com/v/#{video[:id]}?version=3&amp;f=videos&amp;app=youtube_gdata")
     
     
      
    end

  end
end