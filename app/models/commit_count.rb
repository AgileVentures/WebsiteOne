# frozen_string_literal: true

require 'open-uri'

class CommitCount < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :user, :project, :commit_count, presence: true
  validates_uniqueness_of :user, scope: :project
end
