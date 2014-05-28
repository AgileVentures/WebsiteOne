require 'spec_helper'

describe Scrum do

  query = {cassette_name: 'scrums_controller/videos_by_query'}
  describe '#videos_by', vcr: query do
    subject { Scrum.videos_by(:query => "agile ventures scrums", :max_results => 20) }

    it 'queries the YouTubeIt API' do
      expect(subject).to respond_to :videos
      expect(subject.videos.length).to eq 20
    end
  end
  describe '#get_last_query_date' do
    context 'no scrums in database' do
      it 'should return the stored date and time of the last YouTubeIt API query' do
        expect(Scrum.get_last_query_date).to be_nil
      end
    end
  end
end
