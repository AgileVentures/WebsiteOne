class Project < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  validates :title, :description, :status, presence: true
  acts_as_followable
  belongs_to :user
  has_many :documents

  def self.search(search, page)
    order('LOWER(title)').where('title LIKE ?', "%#{search}%").paginate(per_page: 5, page: page)
  end


  def url_for_me(action)
    if action == 'show'
      "/projects/#{to_param}"
    else
      "/projects/#{to_param}/#{action}"
    end
  end
end
