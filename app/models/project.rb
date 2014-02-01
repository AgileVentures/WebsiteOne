class Project < ActiveRecord::Base
  validates :title, :description, :status, presence: true
  acts_as_followable

  belongs_to :user
  has_many :documents


  def url_for_me(action)
    if action == 'show'
      "/projects/#{to_param}"
    else
      "/projects/#{to_param}/#{action}"
    end
  end
end
