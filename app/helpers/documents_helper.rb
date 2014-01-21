module DocumentsHelper
  # TODO Bryan: After being accepted as safe, this should move to the document
  # mercury update to sanitize html before it saves into the database
  def clean_html(html)
    raw sanitize html, tags: %w(h1 h2 h3 h4 h5 h6 b i pre span iframe div img br blockquote p),
                 attributes: %w(src frameborder allowfullscreen style)
  end

  def clean_html_summary(html)
    sanitize(html.gsub(/<[^>]*>/, ' '), tags: [], attributes: []).truncate(250, separator: ' ')
  end
end
