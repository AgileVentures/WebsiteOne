require 'spec_helper'

describe ScrumsController do

  vcr_index = {cassette_name: 'scrums_controller/videos_by_query'}
  describe '#index', vcr: vcr_index do
    context '@scrums instance variable' do
      before { get :index }

      context 'one video' do
        subject { assigns(:scrums).first }

        it 'has an author' do
          expect(subject[:author]).to eq 'Sam Joseph'
        end

        it 'has an id' do
          expect(subject[:id]).to eq 'KdcNSYIX0JQ'
        end

        it 'has a published DateTime' do
          expect(subject[:published]).to eq "2014-04-23".to_date
        end

        it 'has a title' do
          expect(subject[:title]).to eq 'Agile Ventures Atlantic Scrum and Pair Hookup'
        end

          #it 'has content (why is this the same as title?)'
          #cuz nobody enter content data so it takes the same name as the title?
        it 'has a url (use regex to assert this string is a URL)' do
          expect(subject[:url]).to match(/https?:\/\/[\S]+/)
        end
      end

      context 'the array of videos' do
        subject {assigns(:scrums)}

        it 'the last video has an older date than the first video'  do
          expect(subject.last[:published]).to be < subject.first[:published]
        end
      end
    end
  end
end



