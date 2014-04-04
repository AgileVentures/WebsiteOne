require 'act_as_page'

class Article < ActiveRecord::Base
  include ActAsPage

  belongs_to :user
  validates :content, :user_id, presence: true

  acts_as_taggable

  # Bryan: Used to generate paths, used only in testing.
  # Might want to switch to rake generated paths in the future
  def url_for_me(action)
    if action == 'show'
      "/articles/#{self.to_param}"
    else
      "/articles/#{self.to_param}/#{action}"
    end
  end
end
