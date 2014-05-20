require 'spec_helper'

describe ScrumsController do

  vcr_index = { cassette_name: 'scrums_controller/videos_by_query'}
  describe '#index', vcr: vcr_index do
    context '@scrums instance variable' do
      before { get :index }

      context 'one video' do
        subject { assigns(:scrums).first }

        it 'has an author' do
          expect(subject[:author]).to eq 'Sam Joseph'
        end

        it 'has an id'
        it 'has a published DateTime'
        it 'has a title'
        it 'has content (why is this the same as title?)'
        it 'has a url (use regex to assert this string is a URL)'
      end

      context 'the array of videos' do
        subject { assigns :scrums }

        it 'the last video has an older date than the first video'
      end
    end
  end
end
