module Statistics 
  extend ActiveSupport::Concern

  def get_stats_for(entity)
    stats = {}.tap do |stats|
      case entity
      when :articles then
        stats[:count] = Article.count
      when :projects then
        stats[:count] = Project.where("lower(status) = ?", "active").length
      when :members then
        stats[:count] = User.count
      when :documents then
        stats[:count] = Document.count
      when :pairing_minutes then
        stats[:value] = calculate_duration('PairProgramming')
      when :scrum_minutes then
        stats[:value] = calculate_duration('Scrum')
      end
    end
  end

  def calculate_duration(category)
    EventInstance.where(category: category).map(&:duration).sum.to_i/60
  end
end
