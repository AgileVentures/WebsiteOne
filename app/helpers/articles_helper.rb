module ArticlesHelper
  def standard_tags
    %w( Ruby Rails Javascript JQuery Jasmine Cucumber RSpec Git Heroku Travis PostgreSQL Python NodeJS )
  end

  def link_to_tags(tags)
    raw tags.map{ |tag| link_to tag, articles_path(tag: tag) }.join(', ')
  end
end
