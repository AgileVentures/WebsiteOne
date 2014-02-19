class Article < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  belongs_to :user
  validates :title, :content, :user_id, presence: true

  acts_as_taggable

  private
  def slug_candidates
    self.title
  end
end
