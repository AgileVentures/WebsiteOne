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
      end
    end
  end
end
