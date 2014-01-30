module DocumentsHelper
  # TODO Bryan: After being accepted as safe, this should move to the document
  # mercury update to sanitize html before it saves into the database
  def clean_html(html)
    raw sanitize html, tags: %w(h1 h2 h3 h4 h5 h6 b i pre span iframe div img br blockquote p a),
                 attributes: %w(src frameborder allowfullscreen style href)
  end

  def clean_html_summary(html)
    sanitize(html.gsub(/<[^>]*>/, ' '), tags: [], attributes: []).truncate(250, separator: ' ')
  end

  def documents
    @documents = Document.where("project_id = ?", @project.id).order(:created_at)
  end

  def created_by
    if @document.user_id.present?
      user = User.find_by_id(@documentm.user_id)
      if user.first_name.present?
        ['by:', ([user.first_name, user.last_name].join(' '))].join(' ')
      else
        ['by:', (user.email).split('@').first].join(' ')
      end
    else
      'No author'
    end
  end

  def created_date
    date = @documentm.created_at.strftime('Created: %Y-%m-%d')
    (date)
  end


end
