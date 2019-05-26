class ProjectSerializer < ApplicationSerializer
  attributes :id,
             :title,
             :slug,
             :pitch,
             :description,
             :status,
             :github_url,
             :pivotaltracker_url,
             :commit_count,
             :image_url,
             :last_github_update,
             :slack_channel_name,
             :user_id,
             :followers
  
  has_many :documents
  has_many :languages
end
