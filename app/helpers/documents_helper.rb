module DocumentsHelper
  # TODO Bryan: After being accepted as safe, this should move to the document
  # mercury update to sanitize html before it saves into the database
  def clean_html(html)
    raw sanitize html, tags: %w(h1 h2 h3 h4 h5 h6 b i ul li pre span iframe div img br blockquote p a),
                 attributes: %w(src target frameborder allowfullscreen style href)
  end

  def clean_html_summary(html)
    sanitize(html.gsub(/<[^>]*>/, ' '), tags: [], attributes: []).truncate(250, separator: ' ')
  end

  def documents
    @documents = Document.where("project_id = ?", @project.id).order(:created_at)
  end

  def created_date
    "Created #{time_ago_in_words(@document.created_at)} ago"
  end


end
