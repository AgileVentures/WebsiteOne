require 'spec_helper'

RSpec.describe 'Projects API', type: :request do
  describe 'returns projects list' do
    
    it 'succeeds' do
      get '/api/v1/projects'
      
      expect(response).to be_successful
    end
    
    it 'returns list of projects' do
      create_list(:project, 2)
      get '/api/v1/projects'
      
      json = JSON.parse(response.body)
      expect(json.length).to eq 2
    end
    
    it 'includes project documments' do
      create(:project_with_documents, documents_count: 2)
      get '/api/v1/projects'
      json = JSON.parse(response.body)

      expect(json[0]["documents"].count).to eq(2) 
    end

    it 'includes project followers' do
      follower = create(:user)
      project = create(:project)

      follower.follow(project)
      get '/api/v1/projects'
      json = JSON.parse(response.body)

      expect(json[0]["followers"].count).to eq(1)
    end
    it 'includes project langages' do
      language = create(:language, name: 'Ruby on Rails')
      project = create(:project, languages: [language])

      get '/api/v1/projects'
      json = JSON.parse(response.body)

      expect(json[0]["languages"].count).to eq(1)
      # expect(json[0]["languages"][0]["name"]).to eq('Ruby on Rails')
    end
  end
end
