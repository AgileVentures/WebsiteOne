require 'spec_helper'

describe ScrumsHelper do

  describe '#scrum_embed_link' do
    it 'responds to youtube video' do
     

      page.should have_link("http://www.youtube.com/")
    end

  end
end