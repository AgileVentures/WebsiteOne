class Document < ActiveRecord::Base
  include ActAsPage
  include UserNullable
  include PublicActivity::Common

  belongs_to :project
  belongs_to :user

  validates_presence_of :title, :project

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
    [ :title, [:title, :project_title] ]
  end
end
