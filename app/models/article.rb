require 'act_as_page'
require 'acts_as_votable'

class Article < ActiveRecord::Base
  include ActAsPage

  belongs_to :user
  validates :content, :user_id, presence: true

  acts_as_taggable
  acts_as_votable

  # Bryan: Used to generate paths, used only in testing.
  # Might want to switch to rake generated paths in the future
  def url_for_me(action)
    if action == 'show'
      "/articles/#{self.to_param}"
    else
      "/articles/#{self.to_param}/#{action}"
    end
  end

  def vote_value
    self.get_upvotes.size - self.get_downvotes.size
  end

  def authored_by?(user)
    self.user_id == user.id
  end
end
