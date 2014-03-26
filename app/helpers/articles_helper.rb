module ArticlesHelper
  def standard_tags
    %w( Pair-Programming AgileVentures Ruby Rails Javascript jQuery Jasmine Cucumber RSpec Git Heroku )
  end

  def link_to_tags(tags)
    raw tags.map{ |tag| link_to tag, articles_path(tag: tag) }.join(', ')
  end

  class CodeRayify < Redcarpet::Render::HTML
    def block_code(code, language)
      begin
        CodeRay.scan(code, language || :plaintext).div
      rescue Exception => e
        Rails.logger.error e
        '<div class="CodeRay"><pre>Failed to render markdown</pre></div>'
      end
    end
  end

  def from_markdown(markdown)
    return '' if markdown.nil?
    raw markdown_engine.render markdown
  end

  def markdown_preview(markdown)
    return '' if markdown.nil?
    raw sanitize(markdown_engine.render(markdown), tags: %w( p pre code strong em )).truncate(100, separator: ' ')
  end

  def markdown_engine
    renderer = CodeRayify.new autolink: true,
                              fenced_code_blocks: true,
                              no_intra_emphasis: true,
                              superscript: true,
                              footnotes: true

    Redcarpet::Markdown.new renderer,
                            filter_html: true,
                            hard_wrap: true,
                            with_toc_data: true,
                            link_attributes: { target: '_blank', rel: 'nofollow' }
  end
  private :markdown_engine
end
