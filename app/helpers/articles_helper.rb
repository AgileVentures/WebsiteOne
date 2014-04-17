module ArticlesHelper
  def clean_html(html)
    raw sanitize html, tags: %w(h1 h2 h3 h4 h5 h6 b i ul ol li pre span iframe div img br blockquote p a em del strong code tr table thead th tbody td dl dd dt hr input label textarea fieldset),
                 attributes: %w(src alt target frameborder allowfullscreen style href class id lang title align height width border for placeholder name rows columns value)
  end

  def standard_tags
    %w( Pair-Programming AgileVentures Ruby Rails Javascript jQuery Jasmine Cucumber RSpec Git Heroku )
  end

  def link_to_tags(tags)
    clean_html tags.map{ |tag| link_to tag, articles_path(tag: tag) }.join(', ')
  end

  class CodeRayify < Redcarpet::Render::HTML
    def block_code(code, language)
      CodeRay.scan(code, language || :plaintext).div
    rescue Exception => e
      Rails.logger.error e
      'Failed to render code block'
    end
  end

  def from_markdown(markdown)
    return '' if markdown.nil?
    clean_html(markdown_engine.render markdown)
  end

  def markdown_preview(markdown)
    return '' if markdown.nil?
    raw sanitize(markdown_engine.render(markdown), tags: %w( p pre code strong em ), attributes: %w(id class style)).truncate(100, separator: ' ')
  end

  private

  def markdown_engine
    renderer = CodeRayify.new filter_html: true,
                              hard_wrap: true,
                              with_toc_data: true,
                              link_attributes: { target: '_blank', rel: 'nofollow' }

    Redcarpet::Markdown.new renderer,
                            autolink: true,
                            fenced_code_blocks: true,
                            no_intra_emphasis: true,
                            superscript: true,
                            footnotes: true
  end
end
