class Page < ActiveRecord::Base
  self.table_name = "documents"

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  has_paper_trail

  validates :title, presence: true

  def slug_candidates
    [ :title ]
  end
end
