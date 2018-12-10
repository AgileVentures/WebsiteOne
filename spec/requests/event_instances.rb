require 'spec_helper'

describe "/api/v1" do

  describe 'GET /event_instances' do
    before do
      FactoryBot.create_list(:event_instance, 4)
      FactoryBot.create_list(:event_instance, 3, updated: 1.hour.ago)
    end

    context 'json first page' do
      before do
        get "/api/v1/event_instances"
      end

      it "returns json http success" do
        expect(response).to have_http_status(:success)
        expect(response.header['Content-Type']).to include 'application/json'
      end

      it "response with JSON body containing expected Hangouts" do
        hash_body = nil
        expect { hash_body = JSON.parse(response.body) }.not_to raise_exception
        expect(hash_body).to be_an(Array)
        expect(hash_body.length).to eq(6)
        expect(hash_body).to all(be_a(Hash))
        [:id, :event_id, :title, :hangout_url, :category,
         :yt_video_id, :user_id].each do |key|
          expect(hash_body.first).to have_key(key.to_s)
        end
      end
    end

    context 'json second page' do
      before do
        get "/api/v1/event_instances?page=2"
      end

      it "returns json http success" do
        expect(response).to have_http_status(:success)
        expect(response.header['Content-Type']).to include 'application/json'
      end

      it "response with JSON body containing expected Hangouts" do
        hash_body = nil
        expect { hash_body = JSON.parse(response.body) }.not_to raise_exception
        expect(hash_body).to be_an(Array)
        expect(hash_body.length).to eq(1)
        expect(hash_body).to all(be_a(Hash))
        [:id, :event_id, :title, :hangout_url, :category,
         :yt_video_id, :user_id].each do |key|
          expect(hash_body.first).to have_key(key.to_s)
        end
      end
    end
  end
end
