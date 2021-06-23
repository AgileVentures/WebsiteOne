# frozen_string_literal: true

module Statistics
  extend ActiveSupport::Concern

  def get_stats_for(entity)
    stats = {}.tap do |stats|
      case entity
      when :articles
        stats[:count] = Article.count
      when :projects
        stats[:count] = Project.where('lower(status) = ?', 'active').length
      when :members
        stats[:count] = User.count
      when :documents
        stats[:count] = Document.count
      when :pairing_minutes
        stats[:value] = calculate_duration('PairProgramming')
      when :scrum_minutes
        stats[:value] = calculate_duration('Scrum')
      end
    end
  end

  def calculate_duration(category)
    EventInstance.where(category: category).map(&:duration).sum.to_i / 60
  end
end
