# frozen_string_literal: true

class Document < ApplicationRecord
  include ActAsPage
  include UserNullable
  include PublicActivity::Common

  belongs_to :project
  belongs_to :user

  validates :title, :project, presence: true

  delegate :title, to: :project, prefix: true

  # Bryan: Used to generate paths, used only in testing.
  # Might want to switch to rake generated paths in the future
  def url_for_me(action)
    if action == 'show'
      "/projects/#{project.to_param}/documents/#{to_param}"
    else
      "/projects/#{project.to_param}/documents/#{to_param}/#{action}"
    end
  end

  def slug_candidates
    [:title, %i(title project_title)]
  end
end
