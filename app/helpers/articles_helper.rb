module ArticlesHelper
  def standard_tags
    %w( Ruby Rails Javascript JQuery Jasmine Cucumber RSpec Git Heroku Travis PostgreSQL Python NodeJS )
  end

  def link_to_tags(tags)
    raw tags.map{ |tag| link_to tag, articles_path(tag: tag) }.join(', ')
  end

  class CodeRayify < Redcarpet::Render::HTML
    def block_code(code, language)
      CodeRay.scan(code, language).div
    end
  end

  renderer = CodeRayify.new filter_html: true,
                            hard_wrap: true,
                            with_toc_data: true,
                            link_attributes: { target: '_blank', rel: 'nofollow' }

  @@markdown_engine = Redcarpet::Markdown.new(renderer,
                                              autolink: true,
                                              fenced_code_blocks: true,
                                              no_intra_emphasis: true,
                                              superscript: true,
                                              footnotes: true)

  def from_markdown(markdown)
    raw @@markdown_engine.render markdown
  end

  def markdown_preview(markdown)
    raw sanitize(@@markdown_engine.render(markdown), tags: %w( p pre )).truncate(250, separator: ' ')
  end
end
