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
        stats[:count] = EventInstance.where(category: "PairProgramming").map(&:duration).sum
      when :scrum_minutes then
        stats[:count] = EventInstance.where(category: "Scrum").map(&:duration).sum
      end
    end
  end
end
