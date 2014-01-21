class Project < ActiveRecord::Base
  validates :title, :description, :status, presence: true


  has_many :documents


  def url_for_me(action)
    if action == 'show'
      "/projects/#{to_param}"
    else
      "/projects/#{to_param}/#{action}"
    end
  end
end
