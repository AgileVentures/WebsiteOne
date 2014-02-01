class Project < ActiveRecord::Base
  validates :title, :description, :status, presence: true
  acts_as_followable
  belongs_to :user
  has_many :documents

  def self.search(search, page)
    paginate :per_page => 5, :page => page,
             :conditions => ['title like ?', "%#{search}%"],
             :order => 'title'
  end

  def url_for_me(action)
    if action == 'show'
      "/projects/#{to_param}"
    else
      "/projects/#{to_param}/#{action}"
    end
  end
end
