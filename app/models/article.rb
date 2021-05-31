# frozen_string_literal: true

class Article < ApplicationRecord
  include ActAsPage
  include UserNullable
  include PublicActivity::Common

  belongs_to :user
  validates :content, :user, presence: true

  acts_as_taggable
  acts_as_votable

  # Bryan: Used to generate paths, used only in testing.
  # Might want to switch to rake generated paths in the future
  def url_for_me(action)
    if action == 'show'
      "/articles/#{to_param}"
    else
      "/articles/#{to_param}/#{action}"
    end
  end

  def vote_value
    get_upvotes.size - get_downvotes.size
  end

  def authored_by?(user)
    self.user == user
  end
end
