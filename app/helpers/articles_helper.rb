module ArticlesHelper
  def standard_tags
    %w( Git Ruby Rails PostgreSQL Javascript JQuery Python NodeJS Heroku Travis Jasmine Cucumber RSpec )
  end

  def link_to_tags(tags)
    raw tags.map{ |tag| link_to tag, articles_path(tag: tag) }.join(', ')
  end
end
