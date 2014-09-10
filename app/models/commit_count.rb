require 'open-uri'

class CommitCount < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  validates :user, :project, :commit_count, presence: true
  validates_uniqueness_of :user, scope: :project
end

