class Document < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  acts_as_tree
  validates :title, :project_id, presence: true

  def self.search(search, page)
    paginate :per_page => 5, :page => page,
             :conditions => ['title like ?', "%#{search}%"],
             :order => 'project_id'
  end



  def url_for_me(action)
    if action == 'show'
      "/projects/#{project.to_param}/documents/#{to_param}"
    else
      "/projects/#{project.to_param}/documents/#{to_param}/#{action}"
    end

  end
end
