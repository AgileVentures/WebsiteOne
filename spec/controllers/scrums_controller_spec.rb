require 'spec_helper'

describe ScrumsController do

  vcr_index = {cassette_name: 'scrums_controller/videos_by_query'}
  describe '#index', vcr: vcr_index do
    context '@scrums instance variable' do
      before { get :index }

      context 'one video' do
        subject { assigns(:scrums).first }

        it 'has an author' do
          expect(subject[:author]).not_to be_empty
        end

        it 'has an id' do
          expect(subject[:id]).not_to be_empty
        end

        it 'has a published Date' do
          expect(subject[:published]).to be_an_instance_of(Date)
        end

        it 'has a title' do
          expect(subject[:title]).not_to be_empty
        end

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
