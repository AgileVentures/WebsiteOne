# frozen_string_literal: true

module ActAsPage
  def self.included(base)
    base.acts_as_tree
    base.extend FriendlyId
    base.friendly_id :title, use: :slugged
    base.has_paper_trail
    base.validates :title, presence: true
  end
end
