module DocumentsHelper
  def clean_html_summary(html)
    sanitize(html.gsub(/<[^>]*>/, ' '), tags: [], attributes: []).truncate(250, separator: ' ')
  end

  def documents
    @documents = Document.where("project_id = ?", @project.id).order(:created_at)
  end

  def metadata
    "#{@document.versions.last.event.titleize}d #{time_ago_in_words(@document.versions.last.created_at)} ago by #{user_details(@document.versions.last.version_author)}"
  end
end
