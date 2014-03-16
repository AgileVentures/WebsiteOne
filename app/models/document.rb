class Document < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  belongs_to :project
  belongs_to :user
  has_paper_trail

  acts_as_tree
  validates :title, :project_id, presence: true


  #TODO: This is created by Marcelo for future use of pagination
  def self.search(search, page)
    paginate :per_page => 5, :page => page,
             :conditions => ['title like ?', "%#{search}%"],
             :order => 'project_id'
  end

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

  def project_title
    return nil if project_id.nil?
    project.title
  end
end
