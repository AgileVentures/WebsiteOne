class Page < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  has_paper_trail

  validates :title, presence: true

  def slug_candidates
    [ :title ]
  end
end
