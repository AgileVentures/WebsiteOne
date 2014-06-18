require 'open-uri'

class CommitCount < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  def self.update_commit_counts_for(project)
    contributors_json = fetch_contributor_date(project)
    contributors_json.each do |contributor|

    end
  end

  private 

  def self.fetch_contributers(project)
    repo = /github.com\/(.+)/.match(project.github_url)[0]
    JSON.parse(open("https://api.github.com/repos/#{repo}/stats/contributors").read, symbolize_names: true)
  end
end
